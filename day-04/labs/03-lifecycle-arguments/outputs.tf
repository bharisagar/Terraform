output "release_note_path" {
  description = "Path to the release file managed with create_before_destroy and replace_triggered_by."
  value       = local_file.release_note.filename
}

output "operator_note_path" {
  description = "Path to the file that ignores content changes after creation."
  value       = local_file.operator_note.filename
}

output "critical_note_path" {
  description = "Path to the file used for the optional prevent_destroy exercise."
  value       = local_file.critical_note.filename
}

output "lifecycle_lesson" {
  description = "Short reminder of the lifecycle lesson."
  value       = "Lifecycle arguments change how Terraform plans create, update, replacement, and destroy behavior."
}
