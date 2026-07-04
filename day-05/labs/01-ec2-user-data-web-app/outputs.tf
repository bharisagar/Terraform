output "instance_id" {
  description = "ID of the EC2 instance."
  value       = aws_instance.web.id
}

output "public_ip" {
  description = "Public IP address of the web server."
  value       = aws_instance.web.public_ip
}

output "web_url" {
  description = "HTTP URL for the web server."
  value       = "http://${aws_instance.web.public_ip}"
}

output "security_group_id" {
  description = "Security group created for HTTP access."
  value       = aws_security_group.web.id
}

output "bootstrap_method" {
  description = "How the app is installed."
  value       = "EC2 user data, no SSH provisioner"
}
