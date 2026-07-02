output "aws_account_id" {
  description = "AWS account ID used by the provider."
  value       = data.aws_caller_identity.current.account_id
}

output "vpc_id" {
  description = "ID of the custom VPC."
  value       = aws_vpc.this.id
}

output "public_subnet_id" {
  description = "ID of the public subnet."
  value       = aws_subnet.public.id
}

output "availability_zone" {
  description = "Availability zone selected by the data source."
  value       = aws_subnet.public.availability_zone
}

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
  description = "HTTP URL for the Day 2 web server."
  value       = "http://${aws_instance.web.public_ip}"
}

output "ami_id" {
  description = "Amazon Linux 2023 AMI selected by the data source."
  value       = data.aws_ami.amazon_linux_2023.id
}
