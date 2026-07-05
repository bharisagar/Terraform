locals {
  common_tags = {
    Course      = "Bharisagar Terraform AWS Zero to Pro"
    Day         = "01"
    Environment = "learning"
    ManagedBy   = "Terraform"
    Owner       = var.owner_name
    Project     = var.project_name
  }
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

resource "aws_security_group" "day1_private" {
  name_prefix = "${var.project_name}-day1-"
  description = "Day 1 EC2 lab security group with no inbound rules"
  vpc_id      = data.aws_vpc.default.id

  egress {
    description = "Allow outbound traffic for package metadata and AWS service access"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-day1-sg"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_instance" "day1" {
  ami                         = data.aws_ami.amazon_linux_2023.id
  instance_type               = var.instance_type
  subnet_id                   = sort(data.aws_subnets.default.ids)[0]
  vpc_security_group_ids      = [aws_security_group.day1_private.id]
  associate_public_ip_address = false
  monitoring                  = false

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  root_block_device {
    encrypted   = true
    volume_size = var.root_volume_size
    volume_type = "gp3"
  }

  tags = {
    Name = "${var.project_name}-day1-ec2"
  }
}

