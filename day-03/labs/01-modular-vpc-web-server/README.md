# Lab 01: Modular VPC Web Server

This is the main Day 3 AWS project.

It rebuilds the Day 2 VPC web server pattern using local Terraform modules.

## Module Design

```text
01-modular-vpc-web-server/
|-- main.tf
|-- variables.tf
|-- outputs.tf
|-- terraform.tfvars.example
`-- modules/
    |-- network/
    `-- web_server/
```

The root module connects the child modules:

```text
root variables -> root locals -> module.network -> module.web_server -> root outputs
```

## What Terraform Creates

The `network` module creates:

- VPC.
- Public subnet.
- Internet gateway.
- Public route table.
- Route table association.

The `web_server` module creates:

- Security group.
- HTTP ingress rule.
- All outbound egress rule.
- EC2 instance with Apache user data.

## Safety Design

- SSH is not opened.
- Only HTTP port 80 is opened.
- EC2 metadata requires IMDSv2.
- Root EBS volume is encrypted.
- Tags are passed into modules explicitly.
- Root module owns provider configuration.

## Cost Warning

This lab can create paid AWS resources. Use a sandbox account and destroy everything when finished.

```bash
terraform destroy -var-file="terraform.tfvars"
```

## Prerequisites

1. Terraform installed.
2. AWS CLI installed.
3. AWS profile configured.
4. Permissions for VPC, subnet, route table, internet gateway, security group, and EC2.

Verify identity:

```bash
aws sts get-caller-identity --profile terraform-day3
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

Edit values if needed.

## Commands

```bash
terraform fmt -recursive
terraform init
terraform validate
terraform plan -var-file="terraform.tfvars"
terraform apply -var-file="terraform.tfvars"
```

## Verify

After apply, open the `web_url` output in a browser.

## Destroy

```bash
terraform destroy -var-file="terraform.tfvars"
```

## Practice Questions

- Which resources live in `modules/network`?
- Which resources live in `modules/web_server`?
- Which output from `network` becomes an input to `web_server`?
- What would happen if you copied the same code instead of using modules?
- Why should you design modules before applying production resources?
