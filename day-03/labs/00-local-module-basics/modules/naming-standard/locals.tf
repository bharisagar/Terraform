locals {
  name_prefix = "${var.project_name}-${var.environment}"

  standard_tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Owner       = var.owner_name
    Project     = var.project_name
  }

  common_tags = merge(local.standard_tags, var.extra_tags)

  resource_names = {
    for component in var.component_names : component => "${local.name_prefix}-${component}"
  }

  summary = "${local.name_prefix} manages ${length(var.component_names)} named components"
}
