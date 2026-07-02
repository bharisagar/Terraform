locals {
  name_prefix = "${var.project_name}-${var.environment}"

  common_tags = {
    Course      = "Bharisagar Terraform AWS Zero to Pro"
    Day         = "02"
    Environment = var.environment
    ManagedBy   = "Terraform"
    Owner       = var.owner_name
    Project     = var.project_name
  }

  resource_names = {
    vpc            = "${local.name_prefix}-vpc"
    public_subnet  = "${local.name_prefix}-public-subnet"
    internet_gw    = "${local.name_prefix}-igw"
    route_table    = "${local.name_prefix}-public-rt"
    security_group = "${local.name_prefix}-web-sg"
    instance       = "${local.name_prefix}-web-ec2"
  }
}
