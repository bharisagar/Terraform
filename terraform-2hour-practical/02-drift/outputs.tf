output "instance_id" {
  description = "EC2 instance ID used for the drift demo."
  value       = aws_instance.drift_demo.id
}

output "instance_type" {
  description = "Expected instance type from Terraform code."
  value       = aws_instance.drift_demo.instance_type
}

output "security_group_id" {
  description = "Security group ID used for the drift demo."
  value       = aws_security_group.drift_sg.id
}
