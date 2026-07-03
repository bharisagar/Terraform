variable "name_prefix" {
  description = "Prefix used for resource names."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the web server security group will be created."
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID where the EC2 instance will run."
  type        = string
}

variable "http_ingress_cidr" {
  description = "CIDR allowed to reach HTTP port 80."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
}

variable "root_volume_size" {
  description = "Root EBS volume size in GiB."
  type        = number
}

variable "project_name" {
  description = "Project name displayed by user data."
  type        = string
}

variable "environment" {
  description = "Environment displayed by user data."
  type        = string
}

variable "aws_region" {
  description = "AWS region displayed by user data."
  type        = string
}

variable "common_tags" {
  description = "Common tags applied to module resources."
  type        = map(string)
}
