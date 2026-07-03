variable "student_name" {
  description = "Student name written into the migration practice file."
  type        = string
  default     = "Bharisagar Student"
}

variable "environment" {
  description = "Environment label used in the generated note."
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "stage", "prod"], var.environment)
    error_message = "environment must be one of: dev, stage, prod."
  }
}
