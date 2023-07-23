output "ec2_attributes" {
  description = "Public IP of the Ec2 instance"
  value       = aws_instance.this
}