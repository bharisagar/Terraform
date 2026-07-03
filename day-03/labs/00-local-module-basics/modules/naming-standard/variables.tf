variable "project_name" {
  description = "Short lowercase project name."
  type        = string
}

variable "environment" {
  description = "Environment name."
  type        = string
}

variable "owner_name" {
  description = "Owner tag value."
  type        = string
}

variable "component_names" {
  description = "Components that need standardized resource names."
  type        = list(string)
}

variable "extra_tags" {
  description = "Optional tags merged with standard tags."
  type        = map(string)
  default     = {}
}
