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

resource "aws_instance" "imported_server" {
  ami           = local.ami_id
  instance_type = var.instance_type

  tags = {
    Name      = "manually-created-server"
    ManagedBy = "Terraform"
  }
}

# Terraform 1.5+ import block alternative:
# import {
#   id = "i-0abc123456789"
#   to = aws_instance.imported_server
# }
