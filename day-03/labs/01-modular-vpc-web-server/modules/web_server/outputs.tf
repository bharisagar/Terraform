output "security_group_id" {
  description = "ID of the web security group."
  value       = aws_security_group.web.id
}

output "instance_id" {
  description = "ID of the web EC2 instance."
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

output "ami_id" {
  description = "Amazon Linux 2023 AMI selected by the module."
  value       = data.aws_ami.amazon_linux_2023.id
}
