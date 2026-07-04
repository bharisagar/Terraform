variable "aws_region" {
  description = "AWS region."
  type        = string
  default     = "us-east-1"
}

variable "ami_id" {
  description = "Optional AMI override. Leave empty to use the latest Amazon Linux 2023 x86_64 AMI from SSM Parameter Store."
  type        = string
  default     = ""
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t2.micro"
}

variable "bucket_suffix" {
  description = "Lowercase suffix for the demo S3 bucket name. Use letters, numbers, and hyphens only."
  type        = string
  default     = "terraform-practical"
}
