# Day 2: Providers, Variables, Outputs, Data Sources, and AWS VPC Basics

Welcome to Day 2.

Day 1 taught the Terraform workflow. Day 2 teaches how to make Terraform code flexible, readable, and closer to real AWS infrastructure.

Today we move from "create one thing" to "design a small AWS stack."

## Day 2 Outcome

By the end of Day 2, you should be able to:

- Explain what a provider does.
- Pin provider versions with `required_providers`.
- Use variables instead of hardcoded values.
- Add validation rules to variables.
- Use locals for repeated naming and tags.
- Use data sources to read existing information from AWS.
- Use outputs to show important results after apply.
- Understand the basic AWS VPC building blocks.
- Build a small public web server project in a custom VPC.

## Why Day 2 Matters

Beginner Terraform often starts like this:

```hcl
provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "demo" {
  ami           = "ami-123456"
  instance_type = "t3.micro"
}
```

That is fine for a first five minutes.

But professional Terraform cannot stay like that. Real teams need:

- Region as an input.
- Environment as an input.
- Tags applied consistently.
- Provider versions locked.
- AMI IDs discovered safely.
- Resource names generated consistently.
- Outputs that make the result easy to verify.

Day 2 is where Terraform starts becoming reusable.

## Provider Deep Dive

A provider is a Terraform plugin that talks to an external API.

For AWS, the provider is:

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
```

The provider block configures how Terraform connects:

```hcl
provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}
```

Think of it like this:

| Terraform Part | Job |
| --- | --- |
| `required_providers` | Which plugin and version Terraform should install |
| `provider "aws"` | How that plugin connects to AWS |
| `resource "aws_*"` | What the AWS provider should manage |
| `data "aws_*"` | What the AWS provider should read |

## Why Version Constraints Matter

Provider behavior can change between versions. A professional Terraform project does not let provider versions float randomly.

This is good:

```hcl
version = "~> 5.0"
```

It means Terraform can use compatible `5.x` versions but will not jump to a future major version automatically.

When you run `terraform init`, Terraform creates:

```text
.terraform.lock.hcl
```

Commit this lock file. It helps students and teammates use the same provider selections.

## Variables

Variables make Terraform reusable.

Without variables:

```hcl
instance_type = "t3.micro"
```

With variables:

```hcl
instance_type = var.instance_type
```

Variable definition:

```hcl
variable "instance_type" {
  description = "EC2 instance type for the lab."
  type        = string
  default     = "t3.micro"
}
```

## Variable Types

Common types:

| Type | Example |
| --- | --- |
| `string` | `"ap-south-1"` |
| `number` | `8` |
| `bool` | `true` |
| `list(string)` | `["dev", "stage", "prod"]` |
| `map(string)` | `{ Owner = "Bharisagar" }` |
| `object({...})` | Structured input |

## Variable Validation

Validation catches mistakes early.

Example:

```hcl
variable "environment" {
  type    = string
  default = "dev"

  validation {
    condition     = contains(["dev", "stage", "prod"], var.environment)
    error_message = "environment must be dev, stage, or prod."
  }
}
```

This is better than letting a bad value create badly named infrastructure.

## Values From `.tfvars`

Students should not edit `variables.tf` every time.

Use a local values file:

```hcl
aws_region    = "ap-south-1"
aws_profile   = "terraform-day2"
project_name  = "bharisagar-day2"
environment   = "dev"
instance_type = "t3.micro"
```

Run:

```bash
terraform plan -var-file="terraform.tfvars"
```

This repo commits only `.tfvars.example`. Real `terraform.tfvars` files are ignored.

## Locals

Locals are named expressions used inside a module.

They are excellent for:

- Naming prefixes.
- Common tags.
- Derived values.
- Avoiding repeated expressions.

Example:

```hcl
locals {
  name_prefix = "${var.project_name}-${var.environment}"

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}
```

Use variables for inputs. Use locals for calculated values.

## Data Sources

Data sources read information instead of creating it.

Examples:

- Find the latest Amazon Linux AMI.
- List available availability zones.
- Read an existing VPC.
- Read the current AWS account identity.

Example:

```hcl
data "aws_availability_zones" "available" {
  state = "available"
}
```

Then use it:

```hcl
availability_zone = data.aws_availability_zones.available.names[0]
```

Data sources keep your code from depending on stale hardcoded IDs.

## Outputs

Outputs show useful results after apply.

Example:

```hcl
output "instance_id" {
  description = "EC2 instance ID."
  value       = aws_instance.web.id
}
```

Good outputs help the next human verify the deployment.

## AWS VPC Basics

Before building Day 2, understand these AWS components.

| Component | Meaning |
| --- | --- |
| VPC | Your private network boundary in AWS |
| Subnet | A slice of the VPC inside one availability zone |
| Internet Gateway | Lets public subnets reach the internet |
| Route Table | Decides where network traffic goes |
| Route Table Association | Connects a subnet to a route table |
| Security Group | Instance-level virtual firewall |
| AMI | Machine image used to launch EC2 |
| EC2 | Virtual server |

## Public Subnet Mental Model

For an EC2 instance to serve a web page publicly:

1. The VPC needs an internet gateway.
2. The subnet route table needs a route to that internet gateway.
3. The EC2 instance needs a public IP.
4. The security group needs inbound HTTP on port 80.
5. The instance needs software running on port 80.

If any one of those is missing, the browser test fails.

## Day 2 Labs

### Lab 00: Variables, Locals, and Outputs

Path:

```text
day-02/labs/00-variables-locals-outputs
```

This lab does not create AWS resources. It teaches Terraform inputs and outputs safely.

### Lab 01: Custom VPC Public Web Server

Path:

```text
day-02/labs/01-vpc-public-web-server
```

This lab creates:

- VPC.
- Public subnet.
- Internet gateway.
- Route table.
- Security group.
- EC2 web server with user data.

## Professional Habits For Day 2

- Never hardcode account-specific values when a variable makes sense.
- Add variable validation for common mistakes.
- Put reusable names and tags in locals.
- Use data sources for dynamic AWS values.
- Keep `terraform.tfvars` local and commit only `.tfvars.example`.
- Always read whether a plan is creating, replacing, or destroying resources.
- Destroy Day 2 lab resources when finished.

## Day 2 Completion Checklist

You are done with Day 2 when you can answer these:

- What is the difference between a provider and a resource?
- Why should provider versions be constrained?
- What is the difference between a variable and a local?
- Why do we commit `.terraform.lock.hcl`?
- What does a data source do?
- Which AWS resources make a subnet public?
- Why should SSH be disabled in a beginner public web lab?
- What output would you show a teammate after creating a web server?
