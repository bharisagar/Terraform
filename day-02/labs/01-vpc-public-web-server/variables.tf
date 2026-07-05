variable "aws_region" {
  description = "AWS region for the Day 2 VPC lab."
  type        = string
  default     = "ap-south-1"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.aws_region))
    error_message = "aws_region must look like an AWS region, for example ap-south-1."
  }
}

variable "aws_profile" {
  description = "Named AWS CLI profile used by the AWS provider."
  type        = string
  default     = "terraform-day2"

  validation {
    condition     = length(trimspace(var.aws_profile)) >= 2
    error_message = "aws_profile must be a non-empty AWS CLI profile name."
  }
}

variable "project_name" {
  description = "Short lowercase project name used in tags and resource names."
  type        = string
  default     = "bharisagar-day2"

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{2,24}$", var.project_name))
    error_message = "project_name must be 3 to 25 characters, lowercase, and may include numbers or hyphens."
  }
}

variable "environment" {
  description = "Environment name for the lab."
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "stage", "prod"], var.environment)
    error_message = "environment must be one of: dev, stage, prod."
  }
}

variable "owner_name" {
  description = "Owner tag value for cost and audit tracking."
  type        = string
  default     = "bharisagar-student"

  validation {
    condition     = length(trimspace(var.owner_name)) >= 3
    error_message = "owner_name must contain at least 3 characters."
  }
}

variable "vpc_cidr" {
  description = "CIDR block for the custom VPC."
  type        = string
  default     = "10.20.0.0/16"

  validation {
    condition     = can(cidrnetmask(var.vpc_cidr)) && can(regex("/16$", var.vpc_cidr))
    error_message = "vpc_cidr must be a valid /16 CIDR block for this beginner lab, for example 10.20.0.0/16."
  }
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet. Keep it inside vpc_cidr."
  type        = string
  default     = "10.20.1.0/24"

  validation {
    condition     = can(cidrnetmask(var.public_subnet_cidr)) && can(regex("/24$", var.public_subnet_cidr))
    error_message = "public_subnet_cidr must be a valid /24 CIDR block for this beginner lab, for example 10.20.1.0/24."
  }
}

variable "http_ingress_cidr" {
  description = "CIDR allowed to reach the web server on HTTP port 80."
  type        = string
  default     = "0.0.0.0/0"

  validation {
    condition     = can(cidrnetmask(var.http_ingress_cidr))
    error_message = "http_ingress_cidr must be a valid CIDR block."
  }
}

variable "instance_type" {
  description = "EC2 instance type for the web server."
  type        = string
  default     = "t3.micro"

  validation {
    condition     = contains(["t2.micro", "t3.micro", "t3.small"], var.instance_type)
    error_message = "Use one of these Day 2 lab instance types: t2.micro, t3.micro, t3.small."
  }
}

variable "root_volume_size" {
  description = "Root EBS volume size in GiB."
  type        = number
  default     = 8

  validation {
    condition     = var.root_volume_size >= 8 && var.root_volume_size <= 30
    error_message = "root_volume_size must be between 8 and 30 GiB for this lab."
  }
}
