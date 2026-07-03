module "naming" {
  source = "./modules/naming-standard"

  component_names = var.component_names
  environment     = var.environment
  extra_tags      = var.extra_tags
  owner_name      = var.owner_name
  project_name    = var.project_name
}
