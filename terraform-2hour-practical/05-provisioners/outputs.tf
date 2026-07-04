output "instance_id" {
  description = "EC2 instance ID for the provisioner demo."
  value       = aws_instance.provisioner_demo.id
}

output "public_ip" {
  description = "Use this to open the deployed nginx page."
  value       = aws_instance.provisioner_demo.public_ip
}

output "ssh_command" {
  description = "Copy and run this to SSH into the server and verify setup."
  value       = "ssh -i ${var.private_key_path} ec2-user@${aws_instance.provisioner_demo.public_ip}"
}
