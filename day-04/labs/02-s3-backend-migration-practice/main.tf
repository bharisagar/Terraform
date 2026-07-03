locals {
  migration_note = [
    "Student: ${var.student_name}",
    "Environment: ${var.environment}",
    "This file exists so you can practice local-to-S3 state migration.",
    "Backend lock mode: S3 lockfile with use_lockfile = true.",
  ]
}

resource "local_file" "migration_practice" {
  filename             = "${path.module}/generated/day-04-migration-practice.txt"
  content              = join("\n", local.migration_note)
  file_permission      = "0644"
  directory_permission = "0755"
}
