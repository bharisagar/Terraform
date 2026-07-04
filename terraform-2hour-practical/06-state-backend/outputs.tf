output "instance_id" {
  description = "EC2 instance ID to inspect in remote state."
  value       = aws_instance.state_demo.id
}

output "s3_bucket" {
  description = "Demo application bucket tracked in Terraform state."
  value       = aws_s3_bucket.app_data.bucket
}

output "iam_role_arn" {
  description = "IAM role ARN that appears in state."
  value       = aws_iam_role.app_role.arn
}

output "workspace_state_key" {
  description = "Relative S3 key where this workspace state is stored."
  value       = terraform.workspace == "default" ? "terraform.tfstate" : "env/${terraform.workspace}/terraform.tfstate"
}

output "workspace_lock_key" {
  description = "Relative S3 key used for the S3 state lock file while Terraform is running."
  value       = terraform.workspace == "default" ? "terraform.tfstate.tflock" : "env/${terraform.workspace}/terraform.tfstate.tflock"
}
