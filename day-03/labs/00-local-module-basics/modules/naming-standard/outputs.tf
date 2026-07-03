output "name_prefix" {
  description = "Standard name prefix."
  value       = local.name_prefix
}

output "resource_names" {
  description = "Generated names keyed by component."
  value       = local.resource_names
}

output "common_tags" {
  description = "Merged standard and extra tags."
  value       = local.common_tags
}

output "summary" {
  description = "Short module summary."
  value       = local.summary
}
