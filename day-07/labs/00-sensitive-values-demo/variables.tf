variable "app_name" {
  description = "Application name."
  type        = string
  default     = "bharisagar-secure-app"
}

variable "database_username" {
  description = "Example database username."
  type        = string
  default     = "app_user"
}

variable "database_password" {
  description = "Fake example password for sensitivity demo. Do not use real secrets."
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.database_password) >= 12
    error_message = "database_password must be at least 12 characters."
  }
}
