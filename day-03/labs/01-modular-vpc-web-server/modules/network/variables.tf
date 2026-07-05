variable "name_prefix" {
  description = "Prefix used for resource names."
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string

  validation {
    condition     = can(cidrnetmask(var.vpc_cidr)) && can(regex("/16$", var.vpc_cidr))
    error_message = "vpc_cidr must be a valid /16 CIDR block for this beginner module."
  }
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet."
  type        = string

  validation {
    condition     = can(cidrnetmask(var.public_subnet_cidr)) && can(regex("/24$", var.public_subnet_cidr))
    error_message = "public_subnet_cidr must be a valid /24 CIDR block for this beginner module."
  }
}

variable "common_tags" {
  description = "Common tags applied to module resources."
  type        = map(string)
}
