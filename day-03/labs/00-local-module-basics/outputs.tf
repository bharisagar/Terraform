output "name_prefix" {
  description = "Standard name prefix returned by the child module."
  value       = module.naming.name_prefix
}

output "resource_names" {
  description = "Generated resource names returned by the child module."
  value       = module.naming.resource_names
}

output "common_tags" {
  description = "Standard tags returned by the child module."
  value       = module.naming.common_tags
}

output "module_summary" {
  description = "Human-readable module summary."
  value       = module.naming.summary
}
