locals {
  release_lines = [
    "Terraform Lifecycle Arguments Lab",
    "Student: ${var.student_name}",
    "Application version: ${var.app_version}",
    "create_before_destroy creates the replacement first when possible.",
    "replace_triggered_by can force replacement from another managed resource change.",
    "ignore_changes can intentionally ignore selected drift.",
    "prevent_destroy can protect critical resources from accidental deletion.",
  ]
}

resource "terraform_data" "app_version" {
  input = var.app_version

  lifecycle {
    precondition {
      condition     = can(regex("^v[0-9]+\\.[0-9]+\\.[0-9]+$", var.app_version))
      error_message = "app_version must use vMAJOR.MINOR.PATCH format, for example v1.0.0."
    }
  }
}

resource "local_file" "release_note" {
  filename             = "${path.module}/generated/release-${var.app_version}.txt"
  content              = join("\n", concat(local.release_lines, [""]))
  file_permission      = "0644"
  directory_permission = "0755"

  lifecycle {
    create_before_destroy = true
    replace_triggered_by  = [terraform_data.app_version.output]
  }
}

resource "local_file" "operator_note" {
  filename             = "${path.module}/generated/operator-note.txt"
  content              = "Owner: ${var.student_name}\nFooter: ${var.note_footer}\nGenerated at: ${timestamp()}\n"
  file_permission      = "0644"
  directory_permission = "0755"

  lifecycle {
    ignore_changes = [content]
  }
}

resource "local_file" "critical_note" {
  filename             = "${path.module}/generated/critical-note.txt"
  content              = "This file represents a critical resource such as a database or state bucket.\n"
  file_permission      = "0644"
  directory_permission = "0755"

  # Optional exercise:
  # Uncomment this block, run `terraform plan -destroy`, then comment it again before cleanup.
  #
  # lifecycle {
  #   prevent_destroy = true
  # }
}
