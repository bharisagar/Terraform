locals {
  note_lines = [
    "Student: ${var.student_name}",
    "Lesson: ${var.lesson_name}",
    "Resource address: local_file.state_note",
    "State is Terraform memory.",
    "Do not commit terraform.tfstate.",
  ]
}

resource "local_file" "state_note" {
  filename             = "${path.module}/generated/day-04-state-note.txt"
  content              = join("\n", local.note_lines)
  file_permission      = "0644"
  directory_permission = "0755"
}
