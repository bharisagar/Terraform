output "state_bucket_name" {
  description = "S3 bucket name for Terraform remote state."
  value       = aws_s3_bucket.state.bucket
}

output "state_bucket_region" {
  description = "AWS region for the backend bucket."
  value       = var.aws_region
}

output "backend_hcl" {
  description = "Example backend block for projects that should use this bucket."
  value       = <<EOT
terraform {
  backend "s3" {
    bucket       = "${aws_s3_bucket.state.bucket}"
    key          = "day-04/example/terraform.tfstate"
    region       = "${var.aws_region}"
    profile      = "${var.aws_profile}"
    use_lockfile = true
  }
}
EOT
}

output "migration_command" {
  description = "Command used after adding backend.tf to a project."
  value       = "terraform init -migrate-state"
}
