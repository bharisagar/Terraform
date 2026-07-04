locals {
  name_prefix = "${var.project_name}-${var.environment}"

  common_tags = {
    Course      = "Bharisagar Terraform AWS Zero to Pro"
    Day         = "05"
    Environment = var.environment
    ManagedBy   = "Terraform"
    Owner       = var.owner_name
    Project     = var.project_name
  }
}
