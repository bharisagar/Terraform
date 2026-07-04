provider "aws" {
  region = var.aws_region
}

data "aws_ssm_parameter" "al2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

data "aws_caller_identity" "current" {}

locals {
  env    = terraform.workspace
  ami_id = var.ami_id != "" ? var.ami_id : data.aws_ssm_parameter.al2023.value
}

resource "aws_instance" "state_demo" {
  ami           = local.ami_id
  instance_type = var.instance_type

  tags = {
    Name        = "${local.env}-state-demo-server"
    Environment = local.env
    ManagedBy   = "Terraform"
  }
}

resource "aws_s3_bucket" "app_data" {
  bucket        = "${local.env}-app-data-${data.aws_caller_identity.current.account_id}-${var.bucket_suffix}"
  force_destroy = true

  tags = {
    Name        = "${local.env}-app-data"
    Environment = local.env
    ManagedBy   = "Terraform"
  }
}

resource "aws_iam_role" "app_role" {
  name = "${local.env}-app-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })

  tags = {
    Environment = local.env
    ManagedBy   = "Terraform"
  }
}
