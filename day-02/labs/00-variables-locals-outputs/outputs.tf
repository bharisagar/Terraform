output "name_prefix" {
  description = "Calculated name prefix used by resources."
  value       = local.name_prefix
}

output "common_tags" {
  description = "Merged tags that would be applied to AWS resources."
  value       = local.common_tags
}

output "example_resource_names" {
  description = "Example resource names generated from variables and locals."
  value       = local.example_resource_names
}

output "example_security_group_rules" {
  description = "Example web security group rules generated from a list variable."
  value       = local.example_security_group_rules
}
