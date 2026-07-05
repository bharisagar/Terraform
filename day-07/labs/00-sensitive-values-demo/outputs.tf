output "safe_app_name" {
  description = "Non-sensitive app name."
  value       = var.app_name
}

output "database_username" {
  description = "Example username."
  value       = var.database_username
}

output "connection_summary" {
  description = "Sensitive object that includes the password."
  value       = local.connection_summary
  sensitive   = true
}

output "security_lesson" {
  description = "Key reminder."
  value       = "Sensitive output hides display, but state still needs protection."
}
