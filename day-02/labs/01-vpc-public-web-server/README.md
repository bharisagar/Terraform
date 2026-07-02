# Lab 01: Custom VPC Public Web Server

This is the main Day 2 AWS project.

You will create a small public web server stack using Terraform and a custom VPC.

## What Terraform Creates

- One VPC.
- One public subnet.
- One internet gateway.
- One public route table.
- One route table association.
- One security group.
- One inbound HTTP rule.
- One outbound rule.
- One EC2 instance running a small Apache web page.

## What Terraform Reads

- Current AWS account identity.
- Available availability zones.
- Latest Amazon Linux 2023 AMI.

## Safety Design

- SSH is not opened.
- Only HTTP port 80 is opened.
- EC2 metadata requires IMDSv2.
- Root EBS volume is encrypted.
- Tags are applied through provider default tags.
- Values are controlled through variables.

## Cost Warning

This lab can create paid AWS resources. Use a sandbox account and destroy everything when you finish.

```bash
terraform destroy -var-file="terraform.tfvars"
```

## Prerequisites

1. Terraform installed.
2. AWS CLI installed.
3. AWS profile configured.
4. Permissions to create VPC, subnet, route table, internet gateway, security group, and EC2.

Verify your identity first:

```bash
aws sts get-caller-identity --profile terraform-day2
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

Read the plan. You should see new VPC, network, security group, and EC2 resources.

Apply only if you are in a sandbox AWS account:

```bash
terraform apply -var-file="terraform.tfvars"
```

## Verify

After apply, Terraform prints `web_url`.

Open it in a browser or run:

```bash
curl http://PUBLIC_IP_FROM_OUTPUT
```

You should see a simple Day 2 Bharisagar Terraform page.

## Destroy

When finished:

```bash
terraform destroy -var-file="terraform.tfvars"
```

## Troubleshooting

### The web page does not load immediately

Wait 1 to 2 minutes. User data needs time to install and start Apache.

### Authentication failed

Run:

```bash
aws sts get-caller-identity --profile terraform-day2
```

Fix AWS CLI credentials before running Terraform again.

### Instance type unavailable

Change `instance_type` in `terraform.tfvars` to another allowed type from `variables.tf`.

### CIDR conflict

If `10.20.0.0/16` conflicts with another network in your account, change both `vpc_cidr` and `public_subnet_cidr` together.
