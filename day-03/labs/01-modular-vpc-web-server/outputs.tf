output "aws_account_id" {
  description = "AWS account ID used by the provider."
  value       = data.aws_caller_identity.current.account_id
}

output "vpc_id" {
  description = "VPC ID from the network module."
  value       = module.network.vpc_id
}

output "public_subnet_id" {
  description = "Public subnet ID from the network module."
  value       = module.network.public_subnet_id
}

output "availability_zone" {
  description = "Availability zone selected by the network module."
  value       = module.network.availability_zone
}

output "security_group_id" {
  description = "Security group ID from the web server module."
  value       = module.web_server.security_group_id
}

output "instance_id" {
  description = "EC2 instance ID from the web server module."
  value       = module.web_server.instance_id
}

output "web_url" {
  description = "HTTP URL from the web server module."
  value       = module.web_server.web_url
}

output "module_map" {
  description = "Summary of module boundaries."
  value = {
    network_module    = "modules/network"
    web_server_module = "modules/web_server"
  }
}
