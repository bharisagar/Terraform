output "environment_summary" {
  description = "Environment-specific values produced from tfvars."
  value       = local.environment_summary
}

output "promotion_hint" {
  description = "How to think about this environment."
  value       = var.environment == "prod" ? "Review prod plans carefully before apply." : "Use this environment for fast validation."
}
