variable "project_name" {
  description = "Short lowercase project name used for resource names."
  type        = string
  default     = "bharisagar-platform"

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{2,30}$", var.project_name))
    error_message = "project_name must be 3 to 31 characters, lowercase, and may include numbers or hyphens."
  }
}

variable "environment" {
  description = "Deployment environment name."
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "stage", "prod"], var.environment)
    error_message = "environment must be one of: dev, stage, prod."
  }
}

variable "aws_region" {
  description = "AWS region name used in generated examples."
  type        = string
  default     = "ap-south-1"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.aws_region))
    error_message = "aws_region must look like an AWS region, for example ap-south-1."
  }
}

variable "owner_name" {
  description = "Owner name used for tags."
  type        = string
  default     = "bharisagar-student"

  validation {
    condition     = length(trimspace(var.owner_name)) >= 3
    error_message = "owner_name must contain at least 3 characters."
  }
}

variable "cost_center" {
  description = "Cost center tag value for learning infrastructure."
  type        = string
  default     = "terraform-learning"
}

variable "web_ports" {
  description = "TCP ports that a web security group might allow."
  type        = list(number)
  default     = [80, 443]

  validation {
    condition     = alltrue([for port in var.web_ports : port > 0 && port <= 65535])
    error_message = "Every web port must be between 1 and 65535."
  }
}

variable "extra_tags" {
  description = "Optional tags merged into common_tags."
  type        = map(string)
  default = {
    Training = "Day-02"
  }
}
