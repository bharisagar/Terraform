# Terraform 2-Hour Practical

Instructor-friendly Terraform labs for students who already know the basic `init -> plan -> apply -> destroy` workflow and now need to understand the real-world operational topics: workspaces, drift, import, forced replacement, lifecycle arguments, provisioners, state, and locking.

This folder is intended to be pushed into the existing GitHub repo as a separate directory:

```text
bharisagar/Terraform/
`-- terraform-2hour-practical/
```

## What Students Will Learn

By the end of this practical, students should be able to explain and demonstrate:

- How Terraform state remembers what infrastructure Terraform manages.
- How workspaces separate environments while reusing the same code.
- How `terraform plan` detects drift when real AWS infrastructure no longer matches code.
- How `terraform import` brings an existing manually-created resource under Terraform control.
- How `terraform apply -replace=...` recreates a broken resource without changing the code.
- How lifecycle arguments such as `ignore_changes` affect Terraform plans.
- How provisioners work, when they run, and why they should be used carefully.
- How remote state in S3 enables team collaboration.
- How state locking prevents two people from writing the same state at the same time.

## Folder Structure

```text
terraform-2hour-practical/
|-- 01-workspaces/       # Same code, different environments
|-- 02-drift/            # Detect and correct manual AWS changes
|-- 03-import/           # Bring existing AWS resources under Terraform
|-- 04-taint-replace/    # Force resource replacement and lifecycle behavior
|-- 05-provisioners/     # local-exec, file, remote-exec, null_resource
`-- 06-state-backend/    # S3 remote state and state locking
```

Each topic is a standalone Terraform root module. Run commands from inside one topic folder at a time.

## Prerequisites

Install and verify these before class:

```bash
terraform version
aws --version
aws sts get-caller-identity
```

Recommended versions:

- Terraform `>= 1.5.0` for most topics because Topic 3 shows modern import blocks.
- Terraform `>= 1.10.0` for Topic 6 because the S3 backend demo uses the modern `use_lockfile` argument.
- AWS CLI v2.
- An AWS account where you can create EC2, S3, IAM role, VPC, security group, route table, and S3 backend resources.

For Topic 5, create an EC2 key pair before class:

```bash
# In AWS Console:
# EC2 -> Key Pairs -> Create key pair
# Name: demo-keypair
# Type: RSA
# Format: .pem

mkdir -p ~/.ssh
mv ~/Downloads/demo-keypair.pem ~/.ssh/
chmod 400 ~/.ssh/demo-keypair.pem
```

Windows students should use Git Bash or WSL for the shell examples, especially Topic 5 because it uses SSH and Bash scripts.

## Safety And Cost Notes

Use a training AWS account if possible. The examples are intentionally small, but AWS Free Tier is not a guarantee. Always run the cleanup commands at the end of each topic.

Do not commit generated Terraform files or secrets:

- Do not commit `.terraform/`.
- Do not commit `terraform.tfstate`, `terraform.tfstate.backup`, or `terraform.tfstate.d/`.
- Do not commit `.tfvars` files that contain real values.
- Do not commit `.pem` SSH keys.
- Do not commit provisioner logs such as `created_servers.log` or `destroyed_servers.log`.

This repository includes a `.gitignore` for those files.

## Before Running A Topic

Use the same basic flow in each folder:

```bash
cd 01-workspaces
terraform init
terraform plan
terraform apply -auto-approve

# Always clean up before moving on.
terraform destroy -auto-approve
```

Some topics intentionally require manual AWS Console steps. Read the topic README before applying.

The EC2 examples use the public AWS Systems Manager Parameter Store alias for the latest Amazon Linux 2023 x86_64 AMI:

```text
/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64
```

That avoids hardcoding an AMI ID that becomes stale. If a demo needs to match a manually-created instance exactly, override `ami_id` with the real AMI ID.

## Session Plan

| Time | Folder | Topic | Instructor Goal |
|---:|---|---|---|
| 0:00-0:25 | `01-workspaces` | Workspaces | Same code can create isolated `dev`, `staging`, and `prod` resources. |
| 0:25-0:35 | `02-drift` | Drift | `terraform plan` compares state, code, and real infrastructure. |
| 0:35-0:45 | `03-import` | Import | Existing resources can enter Terraform state without being recreated. |
| 0:45-0:55 | `04-taint-replace` | Replacement + lifecycle | `-replace` forces a clean resource rebuild and `ignore_changes` controls selected drift. |
| 0:55-1:15 | `05-provisioners` | Provisioners | Terraform can run local and remote commands, but this is a last-resort tool. |
| 1:15-1:40 | `06-state-backend` | Remote state | Teams use shared state and locking to avoid state corruption. |
| 1:40-2:00 | All | Challenge + Q&A | Students repeat key workflows without the instructor driving. |

## Core Concepts To Explain

### Provider

A provider is Terraform's plugin for a platform. In these labs, the AWS provider translates Terraform resources like `aws_instance` and `aws_s3_bucket` into AWS API calls.

Students should understand that Terraform itself is not AWS-specific. Terraform Core reads configuration, builds a dependency graph, stores state, and asks providers to create, read, update, or delete real infrastructure.

### Resource

A resource is one object Terraform manages, such as:

```hcl
resource "aws_instance" "app_server" {
  ami           = data.aws_ssm_parameter.al2023.value
  instance_type = "t2.micro"
}
```

The resource address is `aws_instance.app_server`. That address is how Terraform connects the code block to the object in state.

### State

State is Terraform's memory. It maps Terraform addresses to real cloud objects:

```text
aws_instance.app_server -> i-0123456789abcdef0
```

Without state, Terraform cannot know whether it should create a new instance, update an existing one, or delete one. State can also contain sensitive infrastructure data, so production state must be protected.

### Plan

`terraform plan` compares three things:

```text
Configuration code + Terraform state + Real infrastructure
```

The plan output symbols matter:

| Symbol | Meaning |
|---|---|
| `+` | Create a new object |
| `~` | Update an existing object |
| `-` | Destroy an object |
| `-/+` | Destroy and recreate |

### Apply And Destroy

`terraform apply` executes the plan and updates state after successful changes. `terraform destroy` plans and applies deletion for everything in the current module and current workspace state.

### Variables, Locals, And Outputs

Variables are inputs. Locals are named expressions used inside a module. Outputs are values Terraform prints after apply and can expose to other modules.

This practical uses variables for region, instance type, SSH key names, and optional AMI override. It uses locals to compute workspace-specific values. It uses outputs so students can inspect instance IDs, IPs, bucket names, and state paths.

### Data Sources

Data sources read information that already exists outside Terraform. The labs use the AWS SSM parameter data source to read the latest Amazon Linux 2023 AMI ID instead of hardcoding an old AMI.

### Lifecycle Meta-Argument

The `lifecycle` block changes how Terraform handles one resource during planning and apply.

Important examples:

- `create_before_destroy`: create the replacement before deleting the old object.
- `prevent_destroy`: block plans that would delete a protected object.
- `ignore_changes`: ignore selected argument drift after creation.
- `replace_triggered_by`: replace one resource when another managed resource changes.

Use lifecycle arguments deliberately. They are safety tools, but they can also hide drift or make cleanup harder when used without a clear reason.

## Topic 1: Workspaces

Folder: `01-workspaces`

Workspaces let one Terraform configuration keep multiple state files. The same code can create `dev`, `staging`, and `prod` infrastructure, but each workspace has isolated state.

What to show in code:

- `terraform.workspace` returns the active workspace name.
- `lookup(local.instance_type_map, terraform.workspace, "t2.micro")` chooses an instance type per environment.
- Tags and names include the workspace name so resources are easy to identify.
- Bucket names include the AWS account ID and a suffix to avoid global S3 name collisions.

Run:

```bash
cd 01-workspaces
terraform init
terraform workspace show
terraform workspace new dev
terraform apply -auto-approve
terraform output

terraform workspace new prod
terraform apply -auto-approve
terraform output
```

Teaching point:

If `dev` and `prod` shared one state file, destroying `dev` could accidentally touch `prod`. Separate state is what makes workspace isolation possible.

Cleanup:

```bash
terraform workspace select dev
terraform destroy -auto-approve

terraform workspace select prod
terraform destroy -auto-approve

terraform workspace select default
```

## Topic 2: Drift

Folder: `02-drift`

Drift happens when someone changes infrastructure outside Terraform, for example by editing an EC2 instance or security group directly in the AWS Console.

Run:

```bash
cd 02-drift
terraform init
terraform apply -auto-approve
terraform output instance_id
```

Manual demo options:

- Stop the EC2 instance, change its instance type in AWS Console, then start it again.
- Delete the SSH ingress rule from `drift-demo-sg`.

Then run:

```bash
terraform plan
```

Teaching point:

`terraform plan` is not only a preview. It is also a drift detector. It refreshes real infrastructure, compares it with state and code, then tells you what Terraform would do to make reality match the code again.

Cleanup:

```bash
terraform destroy -auto-approve
```

## Topic 3: Import And Refresh

Folder: `03-import`

Import solves the "we already have infrastructure" problem. It brings an existing resource into Terraform state without creating or destroying it.

Instructor setup:

1. Create an EC2 instance manually in the AWS Console.
2. Name it `manually-created-server`.
3. Use the same instance type and AMI as the Terraform code, or override variables to match the real instance.
4. Copy the instance ID.

Run:

```bash
cd 03-import
terraform init
terraform plan
terraform import aws_instance.imported_server i-0abc123456789
terraform state list
terraform state show aws_instance.imported_server
terraform plan
```

Teaching point:

Import only connects state to a real object. It does not automatically write perfect Terraform code for that object. If `terraform plan` still shows changes after import, adjust the configuration until code and reality match.

Modern Terraform also supports import blocks:

```hcl
import {
  id = "i-0abc123456789"
  to = aws_instance.imported_server
}
```

Cleanup:

```bash
terraform destroy -auto-approve
```

This destroys the imported EC2 instance because it is now managed by Terraform.

## Topic 4: Replace

Folder: `04-taint-replace`

Sometimes the code is correct but the real resource is unhealthy. `terraform apply -replace=ADDRESS` tells Terraform to destroy and recreate that one resource.

This topic also includes a lifecycle example:

```hcl
lifecycle {
  ignore_changes = [tags["CreatedAt"]]
}
```

That prevents the changing timestamp tag from causing noisy plans after creation.

Run:

```bash
cd 04-taint-replace
terraform init
terraform apply -auto-approve
terraform output instance_id

terraform apply -replace=aws_instance.app_server
terraform output instance_id
terraform output elastic_ip
```

Teaching point:

The instance ID changes because the EC2 instance is brand new. The Elastic IP stays the same because it is a separate AWS resource attached to the replacement instance.

Students may see `terraform taint` and `terraform untaint` in older code or documentation. Explain them for recognition, but teach `-replace` as the modern workflow.

Cleanup:

```bash
terraform destroy -auto-approve
```

## Topic 5: Provisioners And null_resource

Folder: `05-provisioners`

Provisioners run commands after Terraform creates a resource. This module demonstrates:

- `local-exec`: runs on the machine where Terraform is running.
- `file`: copies a local file to the EC2 instance.
- `remote-exec`: connects over SSH and runs commands on the EC2 instance.
- `null_resource`: runs provisioners without representing a real cloud object.

Run:

```bash
cd 05-provisioners
terraform init
terraform plan
terraform apply -auto-approve
```

Verify:

```bash
cat created_servers.log
terraform output ssh_command
ssh -i ~/.ssh/demo-keypair.pem ec2-user@<public_ip>
cat /tmp/deploy.log
cat /tmp/setup_done.txt
exit
echo "Open: http://$(terraform output -raw public_ip)"
```

Teaching point:

Provisioners are useful for demonstrations and emergency glue, but they are not the preferred production deployment pattern. Prefer immutable images, cloud-init/user data, configuration management, or a CI/CD deployment tool when possible.

Cleanup:

```bash
terraform destroy -auto-approve
cat destroyed_servers.log
```

## Topic 6: Remote State And Locking

Folder: `06-state-backend`

Local state is fine for solo practice. Teams need shared remote state so everyone reads and writes the same infrastructure memory. This demo stores state in S3 and enables S3 lock files.

Run:

```bash
cd 06-state-backend
chmod +x setup-backend.sh
./setup-backend.sh
cat .bucket-name
```

Update `backend.tf`:

```hcl
bucket = "terraform-state-demo-yourname-1234567890"
```

Then run:

```bash
terraform init
terraform workspace new dev
terraform apply -auto-approve
terraform output
```

What to show:

- The state file is now in S3, not just on a laptop.
- The lock file appears during an active operation as a `.tflock` object.
- Bucket versioning is enabled so previous state versions can be recovered.
- Public access is blocked and encryption is enabled because state can contain sensitive data.

Lock demo:

```bash
# Terminal 1
terraform apply -auto-approve

# Terminal 2, while Terminal 1 is still running
terraform apply
```

Teaching point:

Without locking, two users could apply at the same time and overwrite each other's state changes. A lock forces Terraform operations to run one at a time for the same state file.

Legacy note:

Older Terraform S3 backend examples often use DynamoDB for locking. Current Terraform supports native S3 lock files with `use_lockfile = true`, and DynamoDB-based locking is deprecated in current Terraform documentation.

State commands:

```bash
terraform state list
terraform state show aws_instance.state_demo

# Remove from state only. The real AWS bucket keeps running.
terraform state rm aws_s3_bucket.app_data

# Bring it back into state.
terraform import aws_s3_bucket.app_data "$(terraform output -raw s3_bucket)"
```

Cleanup:

```bash
terraform workspace select dev
terraform destroy -auto-approve

aws s3 rm "s3://$(cat .bucket-name)" --recursive
aws s3api delete-bucket --bucket "$(cat .bucket-name)"
```

## Student Challenge

Give students 15 minutes to complete these without step-by-step instructor help:

1. In `01-workspaces`, create a workspace called `staging`, deploy it, and confirm the EC2 name contains `staging`.
2. In `02-drift`, deploy, manually change the EC2 instance type, run `terraform plan`, and explain the drift output.
3. In `04-taint-replace`, deploy, record the EC2 instance ID, run `terraform apply -replace=aws_instance.app_server`, and prove the ID changed.
4. In `05-provisioners`, deploy, SSH into the server, and show `/tmp/deploy.log`.
5. In `06-state-backend`, explain where the state file lives and why locking matters.

## Quick Command Reference

```bash
# Core workflow
terraform init
terraform fmt -recursive
terraform validate
terraform plan
terraform apply -auto-approve
terraform destroy -auto-approve

# Workspaces
terraform workspace show
terraform workspace list
terraform workspace new dev
terraform workspace select dev

# Drift
terraform plan
terraform refresh

# Import
terraform import aws_instance.name i-0abc123456789
terraform state list
terraform state show aws_instance.name

# Force replacement
terraform apply -replace=aws_instance.name

# State management
terraform state list
terraform state show aws_instance.name
terraform state rm aws_instance.name
terraform import aws_s3_bucket.name bucket-name
```

## Troubleshooting

`Unable to locate credentials`

Run `aws configure` or set `AWS_PROFILE`, then verify:

```bash
aws sts get-caller-identity
```

`InvalidAMIID.NotFound`

These labs use the latest Amazon Linux 2023 AMI from SSM Parameter Store. If you override `ami_id`, make sure the AMI exists in the selected region.

`BucketAlreadyExists`

S3 bucket names are global. Topic 1 and Topic 6 include the AWS account ID in app bucket names, but backend bucket names still need to be unique. Re-run `setup-backend.sh` or edit the bucket name.

`Permission denied (publickey)`

Check that Topic 5 uses the correct key pair name and private key path:

```bash
terraform output ssh_command
ls -la ~/.ssh/demo-keypair.pem
chmod 400 ~/.ssh/demo-keypair.pem
```

`Error acquiring the state lock`

This is expected during the lock demo. It means another Terraform operation already holds the lock for that state file.

## GitHub Publishing Checklist

Before pushing this folder to `bharisagar/Terraform`:

```bash
terraform fmt -recursive
```

Then confirm no generated files are staged:

```bash
git status --short
```

Expected source files only:

- `.gitignore`
- `README.md`
- `01-workspaces/` through `06-state-backend/`
- Terraform files, topic READMEs, and demo shell scripts

Do not push state, `.terraform`, `.bucket-name`, `.pem`, or log files.

## References

- [Terraform S3 backend](https://developer.hashicorp.com/terraform/language/backend/s3)
- [Amazon Linux 2023 on EC2](https://docs.aws.amazon.com/linux/al2023/ug/ec2.html)
- [Amazon Linux 2023 package management](https://docs.aws.amazon.com/linux/al2023/ug/package-management.html)
- [AWS public AMI parameters in Systems Manager Parameter Store](https://docs.aws.amazon.com/systems-manager/latest/userguide/parameter-store-public-parameters-ami.html)
