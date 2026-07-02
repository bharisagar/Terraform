variable "student_name" {
  description = "Name printed inside the generated Day 1 note."
  type        = string
  default     = "Bharisagar Student"

  validation {
    condition     = length(trimspace(var.student_name)) >= 2
    error_message = "student_name must contain at least 2 characters."
  }
}

variable "course_name" {
  description = "Course name printed inside the generated note."
  type        = string
  default     = "Bharisagar Terraform AWS Zero to Pro"
}

