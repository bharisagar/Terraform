output "active_workspace" {
  description = "Current Terraform workspace."
  value       = local.active_workspace
}

output "environment" {
  description = "Environment derived from the current workspace."
  value       = local.environment
}

output "example_instance_type" {
  description = "Example size selected by workspace."
  value       = local.instance_type
}

output "example_tags" {
  description = "Tags that would be applied to resources."
  value       = local.tags
}
