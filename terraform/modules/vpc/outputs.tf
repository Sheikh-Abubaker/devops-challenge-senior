output "vpc_id" {
  value = aws_vpc.simple_time_service.id
  description = "VPC ID to use in other modules"
}

output "gateway_id" {
  value = aws_internet_gateway.igw.id
  description = "Internet Gateway ID to use in other modules"
}