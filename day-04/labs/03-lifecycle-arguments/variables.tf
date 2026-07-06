variable "student_name" {
  description = "Student name written into generated local files."
  type        = string
  default     = "Bharisagar Student"

  validation {
    condition     = length(trimspace(var.student_name)) >= 2
    error_message = "student_name must contain at least 2 characters."
  }
}

variable "app_version" {
  description = "Application version used to demonstrate replacement behavior."
  type        = string
  default     = "v1.0.0"
}

variable "note_footer" {
  description = "Footer text for the ignore_changes example."
  type        = string
  default     = "Managed by Terraform lifecycle lab"
}
