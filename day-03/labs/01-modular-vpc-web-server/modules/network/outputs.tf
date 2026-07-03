output "vpc_id" {
  description = "ID of the VPC."
  value       = aws_vpc.this.id
}

output "public_subnet_id" {
  description = "ID of the public subnet."
  value       = aws_subnet.public.id
}

output "availability_zone" {
  description = "Availability zone selected for the public subnet."
  value       = aws_subnet.public.availability_zone
}

output "route_table_id" {
  description = "ID of the public route table."
  value       = aws_route_table.public.id
}
