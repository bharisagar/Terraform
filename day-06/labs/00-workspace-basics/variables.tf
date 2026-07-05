variable "project_name" {
  description = "Project name used in generated workspace examples."
  type        = string
  default     = "bharisagar-workspace"
}

variable "workspace_sizes" {
  description = "Example instance sizes by workspace."
  type        = map(string)
  default = {
    default = "t3.micro"
    dev     = "t3.micro"
    stage   = "t3.small"
    prod    = "t3.medium"
  }
}
