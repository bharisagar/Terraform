output "instance_id" {
  description = "ID of the EC2 instance created by this lab."
  value       = aws_instance.day1.id
}

output "instance_private_ip" {
  description = "Private IP address of the EC2 instance."
  value       = aws_instance.day1.private_ip
}

output "ami_id" {
  description = "Amazon Linux 2023 AMI selected by the data source."
  value       = data.aws_ami.amazon_linux_2023.id
}

output "subnet_id" {
  description = "Default subnet selected for the instance."
  value       = aws_instance.day1.subnet_id
}

output "security_group_id" {
  description = "Security group created by this lab."
  value       = aws_security_group.day1_private.id
}

