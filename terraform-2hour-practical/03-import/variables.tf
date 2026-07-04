variable "aws_region" {
  description = "AWS region."
  type        = string
  default     = "us-east-1"
}

variable "ami_id" {
  description = "Optional AMI override. For import, set this if the manually-created EC2 used a specific AMI."
  type        = string
  default     = ""
}

variable "instance_type" {
  description = "Must match the instance type of the manually-created EC2 instance."
  type        = string
  default     = "t2.micro"
}
