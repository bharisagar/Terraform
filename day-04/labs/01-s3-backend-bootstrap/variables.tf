variable "aws_region" {
  description = "AWS region for the backend bucket."
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
  default     = "terraform-day4"
}

variable "bucket_prefix" {
  description = "Globally unique S3 bucket prefix. A suffix is added automatically."
  type        = string
  default     = "bharisagar-tf-state"

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]{2,40}$", var.bucket_prefix))
    error_message = "bucket_prefix must be lowercase, 3 to 41 characters, and may include hyphens."
  }
}

variable "owner_name" {
  description = "Owner tag value for the backend bucket."
  type        = string
  default     = "bharisagar-student"
}

variable "force_destroy_state_bucket" {
  description = "Whether Terraform may delete a non-empty state bucket. Keep false for safety."
  type        = bool
  default     = false
}
