output "current_workspace" {
  description = "Shows which workspace is currently active."
  value       = terraform.workspace
}

output "ami_id_used" {
  description = "AMI ID selected for the EC2 instance."
  value       = local.ami_id
}

output "instance_id" {
  description = "EC2 instance ID."
  value       = aws_instance.app_server.id
}

output "instance_type_used" {
  description = "Instance type chosen for this workspace."
  value       = aws_instance.app_server.instance_type
}

output "public_ip" {
  description = "Public IP of the EC2 instance."
  value       = aws_instance.app_server.public_ip
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket created for this workspace."
  value       = aws_s3_bucket.app_bucket.bucket
}
