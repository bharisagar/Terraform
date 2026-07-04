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

resource "aws_instance" "app_server" {
  ami           = local.ami_id
  instance_type = var.instance_type

  user_data = <<-EOF
    #!/bin/bash
    echo "Server started at: $(date)" > /tmp/server_start.txt
    echo "Instance ID: $(curl -s http://169.254.169.254/latest/meta-data/instance-id)" >> /tmp/server_start.txt
  EOF

  tags = {
    Name      = "taint-demo-server"
    ManagedBy = "Terraform"
    CreatedAt = timestamp()
  }

  lifecycle {
    ignore_changes = [tags["CreatedAt"]]
  }
}

resource "aws_eip" "app_eip" {
  domain   = "vpc"
  instance = aws_instance.app_server.id

  tags = {
    Name      = "taint-demo-eip"
    ManagedBy = "Terraform"
  }
}
