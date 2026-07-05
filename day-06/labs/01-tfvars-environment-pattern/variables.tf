variable "project_name" {
  description = "Project name."
  type        = string
}

variable "environment" {
  description = "Environment name."
  type        = string

  validation {
    condition     = contains(["dev", "stage", "prod"], var.environment)
    error_message = "environment must be dev, stage, or prod."
  }
}

variable "instance_type" {
  description = "Example EC2 instance type for this environment."
  type        = string
}

variable "enable_deletion_protection" {
  description = "Example production safety setting."
  type        = bool
}

variable "desired_capacity" {
  description = "Example environment capacity."
  type        = number

  validation {
    condition     = var.desired_capacity >= 1 && var.desired_capacity <= 10
    error_message = "desired_capacity must be between 1 and 10."
  }
}
