### IAM Denies to be Removed

- "aws-marketplace-management:*"
- "aws-marketplace:Subscribe"
- "aws-marketplace:Unsubscribe"
- "cloudshell:*"

Any others?

Probably just need to do instructions in guide. Working with IAM is important for these deployments anyway, so can make a short "lesson" out of it.

Other options:
- Tested adding explicit permit for these in another policy, deny still takes precendence
- Do via cloudformation?  Not sure if possible since it will need to modify existing group
- check with qwiklabs team to see if this can be modified on the backened


### Panorama

Will be important to have Panorama to have full bootstrap capabilities. Probably will make one shared Panorama that is already up and publically available. 

Template Stacks / DGs prepped for each student

RBAC / access domain for each student


### General Lab Steps


Launch qwiklab environment
Deploy base infra and Panorama from terraform using AWS cloud shell
Initial Panorama setup? Or existing Panorama
Deploy GWLB (with ASG?) using AWS cloud shell
Manual configuration of endpoints, routes to endpoint, routes to  GW, appliance mode
Manual configuration for sub-interface association
Demo cloudwatch metrics and dynamic address groups


### AWS CLI commands

aws ec2 describe-images --filters "Name=owner-alias,Values=aws-marketplace" --filters Name=name,Values=PA-VM-AWS-10* Name=product-code,Values=6njl1pau431dv1qxipg63mvah --region us-west-2