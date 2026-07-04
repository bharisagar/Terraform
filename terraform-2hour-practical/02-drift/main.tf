terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_ssm_parameter" "al2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

locals {
  ami_id = var.ami_id != "" ? var.ami_id : data.aws_ssm_parameter.al2023.value
}

resource "aws_instance" "drift_demo" {
  ami           = local.ami_id
  instance_type = var.instance_type

  tags = {
    Name      = "drift-demo-server"
    ManagedBy = "Terraform"
    Note      = "Manual console changes are intentional for the drift demo"
  }
}

resource "aws_security_group" "drift_sg" {
  name_prefix = "drift-demo-sg-"
  description = "Security group for Terraform drift demo"

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "drift-demo-sg"
    ManagedBy = "Terraform"
  }
}
