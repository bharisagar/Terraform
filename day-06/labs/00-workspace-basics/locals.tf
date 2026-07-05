locals {
  active_workspace = terraform.workspace
  environment      = terraform.workspace == "default" ? "dev" : terraform.workspace
  instance_type    = lookup(var.workspace_sizes, terraform.workspace, "t3.micro")

  tags = {
    Environment = local.environment
    ManagedBy   = "Terraform"
    Project     = var.project_name
    Workspace   = local.active_workspace
  }
}
