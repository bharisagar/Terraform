terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
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

resource "aws_vpc" "demo_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name      = "provisioner-demo-vpc"
    ManagedBy = "Terraform"
  }
}

resource "aws_subnet" "demo_subnet" {
  vpc_id                  = aws_vpc.demo_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags = {
    Name      = "provisioner-demo-subnet"
    ManagedBy = "Terraform"
  }
}

resource "aws_internet_gateway" "demo_igw" {
  vpc_id = aws_vpc.demo_vpc.id

  tags = {
    Name      = "provisioner-demo-igw"
    ManagedBy = "Terraform"
  }
}

resource "aws_route_table" "demo_rt" {
  vpc_id = aws_vpc.demo_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo_igw.id
  }

  tags = {
    Name      = "provisioner-demo-rt"
    ManagedBy = "Terraform"
  }
}

resource "aws_route_table_association" "demo_rta" {
  subnet_id      = aws_subnet.demo_subnet.id
  route_table_id = aws_route_table.demo_rt.id
}

resource "aws_security_group" "demo_sg" {
  name_prefix = "provisioner-demo-sg-"
  description = "Allow SSH and HTTP for the provisioner demo"
  vpc_id      = aws_vpc.demo_vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  ingress {
    description = "HTTP"
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
    Name      = "provisioner-demo-sg"
    ManagedBy = "Terraform"
  }
}

resource "aws_instance" "provisioner_demo" {
  ami                    = local.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = aws_subnet.demo_subnet.id
  vpc_security_group_ids = [aws_security_group.demo_sg.id]

  tags = {
    Name      = "provisioner-demo-server"
    ManagedBy = "Terraform"
  }

  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    command     = <<-EOT
      echo "====================================" >> created_servers.log
      echo "Server created at: $(date)"          >> created_servers.log
      echo "Instance ID: ${self.id}"             >> created_servers.log
      echo "Public IP:   ${self.public_ip}"      >> created_servers.log
      echo "====================================" >> created_servers.log
      echo "Log written to created_servers.log"
    EOT
  }

  provisioner "file" {
    source      = "${path.module}/deploy.sh"
    destination = "/home/ec2-user/deploy.sh"

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file(pathexpand(var.private_key_path))
      host        = self.public_ip
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo dnf update -y",
      "sudo dnf install -y git",
      "chmod +x /home/ec2-user/deploy.sh",
      "bash /home/ec2-user/deploy.sh",
      "echo 'Server setup complete!' > /tmp/setup_done.txt"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file(pathexpand(var.private_key_path))
      host        = self.public_ip
    }
  }

  provisioner "local-exec" {
    when        = destroy
    interpreter = ["bash", "-c"]
    command     = "echo 'Server ${self.id} is being destroyed at $(date)' >> destroyed_servers.log"
  }
}

resource "null_resource" "post_deployment" {
  triggers = {
    instance_id = aws_instance.provisioner_demo.id
  }

  depends_on = [aws_instance.provisioner_demo]

  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    command     = <<-EOT
      echo ""
      echo "============================================"
      echo "  POST-DEPLOYMENT VERIFICATION"
      echo "  Instance: ${aws_instance.provisioner_demo.id}"
      echo "  Public IP: ${aws_instance.provisioner_demo.public_ip}"
      echo "  Status: All resources deployed successfully"
      echo "============================================"
    EOT
  }
}
