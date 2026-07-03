output "managed_file" {
  description = "File tracked by Terraform state."
  value       = local_file.migration_practice.filename
}

output "state_migration_command" {
  description = "Command to migrate local state after backend.tf is configured."
  value       = "terraform init -migrate-state"
}
