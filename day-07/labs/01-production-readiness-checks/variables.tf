variable "remote_state_enabled" {
  description = "Remote state is configured."
  type        = bool
  default     = true
}

variable "state_locking_enabled" {
  description = "State locking is configured."
  type        = bool
  default     = true
}

variable "provider_versions_pinned" {
  description = "Provider versions are constrained and lock file is committed."
  type        = bool
  default     = true
}

variable "secrets_reviewed" {
  description = "Secrets handling and state exposure were reviewed."
  type        = bool
  default     = true
}

variable "least_privilege_iam" {
  description = "Terraform IAM role follows least privilege."
  type        = bool
  default     = true
}

variable "plan_review_required" {
  description = "Terraform plan review is required before production apply."
  type        = bool
  default     = true
}
