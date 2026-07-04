output "imported_instance_id" {
  description = "ID of the imported EC2 instance."
  value       = aws_instance.imported_server.id
}

output "imported_instance_public_ip" {
  description = "Public IP of the imported EC2 instance."
  value       = aws_instance.imported_server.public_ip
}

output "imported_instance_type" {
  description = "Instance type of the imported EC2 instance."
  value       = aws_instance.imported_server.instance_type
}
