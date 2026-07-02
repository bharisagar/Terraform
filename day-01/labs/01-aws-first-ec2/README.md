# Lab 01: First AWS EC2 With Terraform

This lab creates one small EC2 instance in your AWS account.

It is designed for Day 1 learning, not production hosting.

## Safety Design

This lab intentionally keeps the instance private:

- No SSH key pair.
- No inbound security group rules.
- No public IP address requested.
- Encrypted root volume.
- IMDSv2 required.
- Required tags on every resource.

The goal is to learn Terraform's AWS workflow without opening a server to the internet.

## Cost Warning

EC2 can cost money. Use a sandbox AWS account and destroy the lab when finished.

Run this command at the end:

```bash
terraform destroy -var-file="terraform.tfvars"
```

## Prerequisites

1. Terraform installed.
2. AWS CLI installed.
3. AWS CLI profile configured.
4. Default VPC available in the selected AWS region.

Verify your AWS identity before using Terraform:

```bash
aws sts get-caller-identity --profile terraform-day1
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

Edit `terraform.tfvars` if needed.

## Commands

Run from this folder:

```bash
terraform fmt
terraform init
terraform validate
terraform plan -var-file="terraform.tfvars"
```

Read the plan carefully.

If the plan shows only the expected EC2 and security group resources, apply:

```bash
terraform apply -var-file="terraform.tfvars"
```

After checking outputs, destroy:

```bash
terraform destroy -var-file="terraform.tfvars"
```

## Expected Resources

Terraform should create:

- One security group with no inbound rules.
- One EC2 instance.

Terraform should read:

- Default VPC.
- Default subnets.
- Latest Amazon Linux 2023 AMI matching the filters.

## Troubleshooting

### No default VPC

If the plan fails because no default VPC exists, use another region or wait for Day 2, where we create our own VPC.

### Authentication failed

Run:

```bash
aws sts get-caller-identity --profile terraform-day1
```

Fix AWS CLI authentication before running Terraform again.

### Instance type not available

Change `instance_type` in `terraform.tfvars` to another allowed type listed in `variables.tf`.

