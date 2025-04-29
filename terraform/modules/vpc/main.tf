resource "aws_vpc" "simple_time_service" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "simple-ts-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.simple_time_service.id

  tags = {
    Name = "main-igw"
  }
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.simple_time_service.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "vpc-default-main-rtb"
  }
}

resource "aws_main_route_table_association" "main" {
  vpc_id = aws_vpc.simple_time_service.id
  route_table_id = aws_route_table.main.id

  depends_on = [
    aws_vpc.simple_time_service
  ]
}
