output "subnet_ids" {
  description = "List of subnet IDs"
  value       = [
    aws_subnet.public1_subnet_us_east_1a.id,
    aws_subnet.private2_subnet_us_east_1b.id,
    aws_subnet.public2_subnet_us_east_1b.id,
    aws_subnet.private1_subnet_us_east_1a.id
  ]
}