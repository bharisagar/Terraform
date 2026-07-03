variable "project_name" {
  description = "Short lowercase project name."
  type        = string
  default     = "bharisagar-platform"

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{2,30}$", var.project_name))
    error_message = "project_name must be 3 to 31 characters, lowercase, and may include numbers or hyphens."
  }
}

variable "environment" {
  description = "Environment name."
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "stage", "prod"], var.environment)
    error_message = "environment must be one of: dev, stage, prod."
  }
}

variable "owner_name" {
  description = "Owner tag value."
  type        = string
  default     = "bharisagar-student"
}

variable "component_names" {
  description = "Components that need standardized resource names."
  type        = list(string)
  default     = ["network", "web", "database"]

  validation {
    condition     = alltrue([for name in var.component_names : can(regex("^[a-z][a-z0-9-]{1,24}$", name))])
    error_message = "Each component name must be lowercase and may include numbers or hyphens."
  }
}

variable "extra_tags" {
  description = "Optional tags merged with standard tags."
  type        = map(string)
  default = {
    Training = "Day-03"
  }
}
