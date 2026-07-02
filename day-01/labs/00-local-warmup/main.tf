locals {
  note_lines = [
    "Hello ${var.student_name},",
    "",
    "You created this file with Terraform.",
    "This local lab teaches the same workflow used for AWS:",
    "",
    "1. terraform init",
    "2. terraform plan",
    "3. terraform apply",
    "4. terraform destroy",
    "",
    "Course: ${var.course_name}",
  ]
}

resource "local_file" "day1_note" {
  filename             = "${path.module}/generated/hello-terraform.txt"
  content              = join("\n", local.note_lines)
  file_permission      = "0644"
  directory_permission = "0755"
}

