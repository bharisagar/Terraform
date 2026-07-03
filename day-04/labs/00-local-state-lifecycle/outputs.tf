output "state_resource_address" {
  description = "Terraform address of the tracked local file."
  value       = "local_file.state_note"
}

output "generated_file" {
  description = "Path to the file managed by Terraform."
  value       = local_file.state_note.filename
}

output "state_lesson" {
  description = "Short reminder of the lesson."
  value       = "State maps Terraform addresses to real objects."
}
