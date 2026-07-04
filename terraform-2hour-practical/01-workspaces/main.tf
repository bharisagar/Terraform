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

data "aws_caller_identity" "current" {}

locals {
  instance_type_map = {
    default = "t3.micro"
    dev     = "t3.micro"
    staging = "t3.micro"
    prod    = "t3.small"
  }

  ami_id        = var.ami_id != "" ? var.ami_id : data.aws_ssm_parameter.al2023.value
  instance_type = lookup(local.instance_type_map, terraform.workspace, "t3.micro")

  common_tags = {
    Environment = terraform.workspace
    ManagedBy   = "Terraform"
    Project     = "workspace-demo"
  }
}

resource "aws_instance" "app_server" {
  ami           = local.ami_id
  instance_type = local.instance_type

  tags = merge(local.common_tags, {
    Name = "${terraform.workspace}-app-server"
  })
}

resource "aws_s3_bucket" "app_bucket" {
  bucket        = "${terraform.workspace}-my-app-bucket-${data.aws_caller_identity.current.account_id}-${var.bucket_suffix}"
  force_destroy = true

  tags = merge(local.common_tags, {
    Name = "${terraform.workspace}-app-bucket"
  })
}
