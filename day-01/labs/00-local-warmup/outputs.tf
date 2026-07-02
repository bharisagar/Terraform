output "generated_file" {
  description = "Path of the file created by Terraform."
  value       = local_file.day1_note.filename
}

output "message_preview" {
  description = "First line of the generated note."
  value       = local.note_lines[0]
}

