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

variable "key_name" {
  description = "Name of the AWS key pair to attach to the EC2 instance."
  type        = string
  default     = "demo-keypair"
}

variable "private_key_path" {
  description = "Local path to the .pem private key file for SSH."
  type        = string
  default     = "~/.ssh/demo-keypair.pem"
}

variable "allowed_ssh_cidr" {
  description = "CIDR block allowed to SSH into the demo instance. For class simplicity this defaults to the internet; restrict it to your public IP for safer demos."
  type        = string
  default     = "0.0.0.0/0"
}
