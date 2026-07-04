output "resource_address" {
  description = "Resource address that owns the provisioner."
  value       = "terraform_data.local_exec_demo"
}

output "message" {
  description = "Message passed to the provisioner environment."
  value       = terraform_data.local_exec_demo.output.message
}

output "expected_file" {
  description = "File created by the default Windows local-exec command."
  value       = "${path.module}/generated/local-exec-demo.txt"
}
