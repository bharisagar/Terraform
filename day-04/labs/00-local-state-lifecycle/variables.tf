variable "student_name" {
  description = "Student name written into the state demo file."
  type        = string
  default     = "Bharisagar Student"

  validation {
    condition     = length(trimspace(var.student_name)) >= 2
    error_message = "student_name must contain at least 2 characters."
  }
}

variable "lesson_name" {
  description = "Lesson name written into the state demo file."
  type        = string
  default     = "Day 4 Terraform State"
}
