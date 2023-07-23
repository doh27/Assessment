output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.this[0].id
}

output "public_subnet_ids" {
  description = "List of Public subnet IDs"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "List of Private subnet IDs"
  value       = aws_subnet.private[*].id
}
