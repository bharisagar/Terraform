variable "aws_region" {
  description = "AWS region for the Day 1 lab."
  type        = string
  default     = "ap-south-1"

  validation {
    condition     = length(trimspace(var.aws_region)) >= 5
    error_message = "aws_region must be a valid AWS region name, for example ap-south-1."
  }
}

variable "aws_profile" {
  description = "Named AWS CLI profile used by the AWS provider."
  type        = string
  default     = "terraform-day1"

  validation {
    condition     = length(trimspace(var.aws_profile)) >= 2
    error_message = "aws_profile must be a non-empty AWS CLI profile name."
  }
}

variable "project_name" {
  description = "Short lowercase project name used in tags and names."
  type        = string
  default     = "bharisagar-tf"

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{2,24}$", var.project_name))
    error_message = "project_name must be 3 to 25 characters, lowercase, and may include numbers or hyphens."
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

variable "instance_type" {
  description = "EC2 instance type for the lab."
  type        = string
  default     = "t3.micro"

  validation {
    condition     = contains(["t2.micro", "t3.micro", "t3.small"], var.instance_type)
    error_message = "Use one of these Day 1 lab instance types: t2.micro, t3.micro, t3.small."
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

