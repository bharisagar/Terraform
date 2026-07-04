# Lab 01: EC2 User Data Web App

This is the main Day 5 AWS lab.

It creates an EC2 instance that installs and starts Apache through EC2 user data.

This lab intentionally avoids SSH and `remote-exec`.

## What Terraform Creates

- Security group in the default VPC.
- HTTP ingress rule on port 80.
- All outbound egress rule.
- EC2 instance with user data bootstrap.

## What Terraform Reads

- Default VPC.
- Default subnets.
- Latest Amazon Linux 2023 AMI.

## Safety Design

- SSH is not opened.
- No key pair is configured.
- HTTP is the only inbound rule.
- IMDSv2 is required.
- Root volume is encrypted.
- User data handles bootstrap on first boot.

## Cost Warning

This lab can create paid AWS resources. Use a sandbox AWS account and destroy when finished.

```bash
terraform destroy -var-file="terraform.tfvars"
```

## Prerequisites

1. AWS CLI configured.
2. Default VPC exists in the selected region.
3. Permission to create EC2 and security group resources.

Verify identity:

```bash
aws sts get-caller-identity --profile terraform-day5
```

## Setup

Copy the example variables file.

Windows PowerShell:

```powershell
Copy-Item terraform.tfvars.example terraform.tfvars
```

macOS/Linux:

```bash
cp terraform.tfvars.example terraform.tfvars
```

## Commands

```bash
terraform fmt
terraform init
terraform validate
terraform plan -var-file="terraform.tfvars"
terraform apply -var-file="terraform.tfvars"
```

## Verify

After apply, open the `web_url` output in a browser.

If it does not load immediately, wait 1 to 2 minutes for user data to finish.

## Destroy

```bash
terraform destroy -var-file="terraform.tfvars"
```

## Why User Data Here?

User data is safer than SSH provisioners for this beginner web app because Terraform does not need a private key, no inbound SSH rule is required, and the instance configures itself during boot.
