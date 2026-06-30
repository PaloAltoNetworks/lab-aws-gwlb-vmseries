# Lab builder EC2 (recommended way to run this lab)

Run the lab Terraform from a small EC2 instance instead of CloudShell. CloudShell works but
has a 1 GB home directory (Terraform's providers are larger than that once both stacks init)
and its storage is per-region, so switching regions mid-lab silently drops you into a fresh
empty environment and you end up with duplicate resources or lost state. The builder avoids
all of that: a normal Linux box with a real disk, an IAM role instead of static keys, and
Session Manager instead of SSH keys.

`builder.cfn.yaml` stands up:

- a tiny self-contained VPC with internet egress,
- an EC2 instance (Amazon Linux 2023) with **Terraform, git, and the AWS CLI** pre-installed
  and this repo already cloned to `/home/ec2-user/lab-aws-gwlb-vmseries`,
- an **IAM instance role** (so Terraform authenticates automatically, no access keys), and
- **SSM Session Manager** access (no SSH key, no inbound ports).

> The role uses `AdministratorAccess`. That is intended for a dedicated lab/sandbox account
> only, because the lab itself creates IAM roles and resources across many services. Do not
> launch this in a shared or production account.

## Launch

Console: CloudFormation > Create stack > upload `builder.cfn.yaml` > acknowledge the IAM
capability > Create.

CLI:

```bash
aws cloudformation deploy \
  --template-file builder/builder.cfn.yaml \
  --stack-name gwlb-lab-builder \
  --capabilities CAPABILITY_IAM
  # optional: --parameter-overrides RepoBranch=<branch> InstanceType=t3.large
```

Launch it in whichever region is convenient. It does not have to match the lab's deploy
regions; Terraform deploys to the regions pinned in the tfvars regardless of where the
builder runs.

## Connect

EC2 console > Instances > `gwlb-lab-builder` > **Connect** > **Session Manager**. (Or, if you
have the SSM plugin locally, use the `aws ssm start-session` command from the stack Outputs.)

```bash
sudo su - ec2-user
cd lab-aws-gwlb-vmseries
cat BUILDER-READY.txt   # confirms Terraform installed + repo cloned
terraform version
```

Then follow the lab guide (`README.md`) from the Terraform steps onward.

## Run locally instead (optional)

If you would rather run from your own machine and you already have the AWS CLI + Terraform
set up, that works too: authenticate to the lab account (SSO profile or exported keys), set
your region, and run the same Terraform. We do not document local setup here.

## Teardown

When you are done with the whole lab, after `terraform destroy` of the lab stacks, delete the
builder stack: `aws cloudformation delete-stack --stack-name gwlb-lab-builder`.
