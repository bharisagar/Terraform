variable "name_prefix" {
  description = "Prefix used for resource names."
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet."
  type        = string
}

variable "common_tags" {
  description = "Common tags applied to module resources."
  type        = map(string)
}
