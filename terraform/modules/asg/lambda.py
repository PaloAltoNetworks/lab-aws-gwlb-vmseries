import boto3
import botocore
import logging
import sys
import pprint
import json
from datetime import datetime

logging.basicConfig(stream=sys.stdout, level=logging.DEBUG)
logger = logging.getLogger()
logger.setLevel(logging.INFO)

ec2_client = boto3.client('ec2')
asg_client = boto3.client('autoscaling')

## TODO - Add support for optional EIP creation / association

def lambda_handler(event, context):

    logger.info(f"Received event: {event}")

    if event["detail-type"] == "EC2 Instance-launch Lifecycle Action":
        instance_id = event["detail"]["EC2InstanceId"]
        lifecycle_metadata = json.loads(event['detail']['NotificationMetadata'])
        instance_az, default_eni = get_instance_az(instance_id)

        if instance_az in lifecycle_metadata['additional_enis'].keys():
            logger.info(f"Data found for az: {instance_az} in lifecycle hook metadata.")
        else:
            logger.error(f"No data found for az: {instance_az} in lifecycle hook metadata. Exiting")

        # Check if default ENI needs to be updated to disable source/dest check
        if lifecycle_metadata['default_eni']['source_dest_check'] == "False":
            logger.info(f"Disabling Source / Dest Check for default eni {default_eni}.")
            ec2_client.modify_network_interface_attribute(
                NetworkInterfaceId= default_eni,
                SourceDestCheck= {
                    'Value': False
                }
            )

        for interface in lifecycle_metadata['additional_enis'][instance_az]:
            created_interface = new_interface(instance_id=instance_id, name=interface['name'], 
                            subnet_id=interface['subnet'], attach_index=interface['attach_index'], 
                            security_group_id=interface['security_group'], source_dest_check=interface['source_dest_check'])
            
            # Send ABANDON reponse to ASG and exit if proper return is not received from new_interface function
            if not created_interface:
                try:
                    logger.error(f'Operation Failed. Sending ABANDON life cycle hook for instance {instance_id}')

                    asg_client.complete_lifecycle_action(
                        LifecycleHookName=event['detail']['LifecycleHookName'],
                        AutoScalingGroupName=event['detail']['AutoScalingGroupName'],
                        LifecycleActionToken=event['detail']['LifecycleActionToken'],
                        LifecycleActionResult='ABANDON'
                    )
                    sys.exit(1)

                except botocore.exceptions.ClientError as e:
                    logger.error("Error completing life cycle hook for instance {}: {}".format(instance_id, e.response['Error']['Code']))
                    raise
                
        try:
            logger.info(f'All Operations Complete. Sending CONTINUE life cycle hook for instance {instance_id}')

            asg_client.complete_lifecycle_action(
                LifecycleHookName=event['detail']['LifecycleHookName'],
                AutoScalingGroupName=event['detail']['AutoScalingGroupName'],
                LifecycleActionToken=event['detail']['LifecycleActionToken'],
                LifecycleActionResult='CONTINUE'
            )

        except botocore.exceptions.ClientError as e:
            logger.error("Error completing life cycle hook for instance {}: {}".format(instance_id, e.response['Error']['Code']))


def get_instance_az(instance_id):
    try:
        result = ec2_client.describe_instances(InstanceIds=[instance_id])
        instance_az = result['Reservations'][0]['Instances'][0]['Placement']['AvailabilityZone']
        default_eni = result['Reservations'][0]['Instances'][0]['NetworkInterfaces'][0]['NetworkInterfaceId']

    except botocore.exceptions.ClientError as e:
        logger.error("Error describing the instance: {}".format(e.response['Error']['Code']))
        instance_az = None
        instance_vpc = None

    logger.info(f"Instance: {instance_id} launched in AZ: {instance_az}")   

    return instance_az, default_eni


def new_interface(instance_id, name, subnet_id, attach_index, security_group_id, source_dest_check):
    
    network_interface_id = None

    if subnet_id:
        try:
            network_interface = ec2_client.create_network_interface(SubnetId=subnet_id, Description=name, Groups=[security_group_id])
            network_interface_id = network_interface['NetworkInterface']['NetworkInterfaceId']
            logger.info(f"Created network interface: {network_interface_id} for subnet: {subnet_id}") 

        except botocore.exceptions.ClientError as e:
            logger.error("Error creating network interface: {}".format(e.response['Error']['Code']))
            return False

        try:
            attach_interface = ec2_client.attach_network_interface(
                NetworkInterfaceId=network_interface_id,
                InstanceId=instance_id,
                DeviceIndex=int(attach_index)
            )
            attachment = attach_interface['AttachmentId']
            logger.info(f"Created network attachment: {attachment} for subnet: {subnet_id}") 

        except botocore.exceptions.ClientError as e:
            logger.error("Error attaching network interface: {}".format(e.response['Error']['Code']))
            delete_interface(network_interface_id)
            return False

        try:
            # Modify so new interface is deleted when instance is terminated
            ec2_client.modify_network_interface_attribute(
                Attachment={
                    'AttachmentId': attachment,
                    'DeleteOnTermination': True,
                },
                NetworkInterfaceId= network_interface_id,
            )

            # Modify to set source/dest check to False (typically required for any VM-Series dataplane interfaces, but not for management)
            if source_dest_check == 'False':
                ec2_client.modify_network_interface_attribute(
                    NetworkInterfaceId= network_interface_id,
                    SourceDestCheck= {
                        'Value': False
                    }
                )

        except botocore.exceptions.ClientError as e:
            logger.error("Error modifying network interface: {}".format(e.response['Error']['Code']))
            return False


    return network_interface_id


def delete_interface(network_interface_id):
    try:
        ec2_client.delete_network_interface(
            NetworkInterfaceId=network_interface_id
        )
        return True

    except botocore.exceptions.ClientError as e:
        logger.error("Error deleting network interface: {}".format(e.response['Error']['Code']))



def get_attach_subnets(vpc_id, az_id, subnet_tag_key): # Alternate Method to get interface info from tags instead of lifecycle metadata - no longer used

    # Find all subnets in same AZ with appropriate tag set to create new interfaces to attach to new instance
    subnet_filter = [{'Name' : 'availability-zone','Values' : [az_id]},
                     {'Name' : 'vpc-id', 'Values' : [vpc_id] },
                     {'Name' : 'tag-key', 'Values' : [subnet_tag_key]}
                    ]

    # Empty list to hold identified subnets
    subnet_attach_list = []

    try:
        response = ec2_client.describe_subnets(Filters=subnet_filter)

        for subnet in response['Subnets']:

            subnet_id = subnet['SubnetId']

            for tag in subnet['Tags']:
                if tag['Key'] == subnet_tag_key:
                    logger.info(f"Found subnet: {subnet_id} tagged to be attached as ENI index: {tag['Value']}")
                    subnet_attach_list.append({'subnet_id': subnet_id, 'attach_index': tag['Value'] })

    except botocore.exceptions.ClientError as e:
        logger.error("Error describing subnets: {}".format(e.response['Error']['Code']))
        subnet_attach_list = None

    return subnet_attach_list




if __name__ == '__main__':
    # event = {'detail-type' : 'EC2 Instance-launch Lifecycle Action',
    #             'detail' : {
    #                 'EC2InstanceId' : 'i-0df9a5c210f30a97a'
    #             }
    #         }
    event = {'version': '0', 'id': 'e68f3c31-7a32-9ad3-ac57-0a3e00962062', # Example Event Data for local testing
             'detail-type': 'EC2 Instance-launch Lifecycle Action', 'source': 'aws.autoscaling', 'account': '354128141335', 'time': '2021-01-25T05:25:00Z', 'region': 'eu-west-1', 'resources': ['arn:aws:autoscaling:eu-west-1:354128141335:autoScalingGroup:e865bc70-f69a-4f78-951f-89a26af49ef5:autoScalingGroupName/tn-asgasg1'], 
                'detail': {'LifecycleActionToken': 'e8450784-b2dd-428b-81e9-663dc710a2e2', 'AutoScalingGroupName': 'tn-asgasg1', 'LifecycleHookName': 'tn-asghook1', 'EC2InstanceId': 'i-0df9a5c210f30a97a', 'LifecycleTransition': 'autoscaling:EC2_INSTANCE_LAUNCHING', 
                    'NotificationMetadata': '{"additional_enis":{"eu-west-1b":[{"attach_index":"1","name":"eth1-mgmt","security_group":"sg-04528f3e45bcf036a","source_dest_check":"True","subnet":"subnet-06d2376cfc29fa406"},{"attach_index":"2","name":"eth2-untrust","security_group":"sg-0f82f86157150e802","source_dest_check":"False","subnet":"subnet-0507a9ee851914874"}],"eu-west-1c":[{"attach_index":"1","name":"eth1-mgmt","security_group":"sg-04528f3e45bcf036a","source_dest_check":"True","subnet":"subnet-03fdce1d4a2f32315"},{"attach_index":"2","name":"eth2-untrust","security_group":"sg-0f82f86157150e802","source_dest_check":"False","subnet":"subnet-0c35ac4dd73b0de37"}]},"default_eni":{"security_groups":["sg-0f82f86157150e802"],"source_dest_check":"False","subnets":["subnet-0eaeb6bd58906d31e","subnet-08b34a0d8f119d732"]}}\r\n'}}
    context = ''
    lambda_handler(event, context)