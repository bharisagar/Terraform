locals {
  name_prefix = "${var.project_name}-${var.environment}"

  mandatory_tags = {
    CostCenter  = var.cost_center
    Environment = var.environment
    ManagedBy   = "Terraform"
    Owner       = var.owner_name
    Project     = var.project_name
  }

  common_tags = merge(local.mandatory_tags, var.extra_tags)

  example_resource_names = {
    vpc            = "${local.name_prefix}-vpc"
    public_subnet  = "${local.name_prefix}-public-subnet"
    security_group = "${local.name_prefix}-web-sg"
    instance       = "${local.name_prefix}-web-ec2"
  }

  example_security_group_rules = [
    for port in var.web_ports : {
      description = "Allow TCP ${port}"
      from_port   = port
      protocol    = "tcp"
      to_port     = port
    }
  ]
}
