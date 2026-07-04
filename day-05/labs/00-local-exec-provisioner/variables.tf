variable "message" {
  description = "Message written by the local-exec provisioner."
  type        = string
  default     = "Day 5 local-exec ran successfully."

  validation {
    condition     = length(trimspace(var.message)) >= 5
    error_message = "message must contain at least 5 characters."
  }
}

variable "local_exec_interpreter" {
  description = "Interpreter used by local-exec. Defaults to Windows PowerShell."
  type        = list(string)
  default     = ["PowerShell", "-NoProfile", "-Command"]
}

variable "local_exec_command" {
  description = "Command run by local-exec. Defaults to a Windows PowerShell command."
  type        = string
  default     = "New-Item -ItemType Directory -Force generated | Out-Null; Set-Content -Path generated/local-exec-demo.txt -Value $env:DEMO_MESSAGE"
}
