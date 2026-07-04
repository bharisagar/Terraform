output "instance_id" {
  description = "Watch this ID change after terraform apply -replace."
  value       = aws_instance.app_server.id
}

output "public_ip" {
  description = "Public IP of the EC2 instance."
  value       = aws_instance.app_server.public_ip
}

output "elastic_ip" {
  description = "Elastic IP that is reattached to the replacement instance."
  value       = aws_eip.app_eip.public_ip
}
