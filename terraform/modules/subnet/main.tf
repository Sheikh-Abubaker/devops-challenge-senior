resource "aws_subnet" "public1_subnet_us_east_1a" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.0.0.0/20"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags = {
    Name = "simple-ts-subnet-public1-us-east-1a"
  }
}

resource "aws_subnet" "private1_subnet_us_east_1a" {
  vpc_id            = var.vpc_id
  cidr_block        = "10.0.128.0/20"
  availability_zone = "us-east-1a"
  tags = {
    Name = "simple-ts-subnet-private1-us-east-1a"
  }
}

resource "aws_subnet" "public2_subnet_us_east_1b" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.0.16.0/20"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1b"
  tags = {
    Name = "simple-ts-subnet-public2-us-east-1b"
  }
}

resource "aws_subnet" "private2_subnet_us_east_1b" {
  vpc_id            = var.vpc_id
  cidr_block        = "10.0.144.0/20"
  availability_zone = "us-east-1b"
  tags = {
    Name = "simple-ts-subnet-private2-us-east-1b"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.gateway_id
  }

  tags = {
    Name = "rtb-public"
  }
}

resource "aws_route_table_association" "public1a_subnet_assoc" {
  subnet_id      = aws_subnet.public1_subnet_us_east_1a.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public2b_subnet_assoc" {
  subnet_id      = aws_subnet.public2_subnet_us_east_1b.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_eip" "nat_eip_1a" {
  domain = "vpc"
  tags = {
    Name = "simple-ts-nat-eip-1a"
  }
}

resource "aws_eip" "nat_eip_1b" {
  domain = "vpc"
  tags = {
    Name = "simple-ts-nat-eip-1b"
  }
}

resource "aws_nat_gateway" "nat_gw_1a" {
  allocation_id = aws_eip.nat_eip_1a.id
  subnet_id     = aws_subnet.public1_subnet_us_east_1a.id

  tags = {
    Name = "simple-ts-NAT-gw-1a"
  }
}

resource "aws_nat_gateway" "nat_gw_1b" {
  allocation_id = aws_eip.nat_eip_1b.id
  subnet_id     = aws_subnet.public2_subnet_us_east_1b.id

  tags = {
    Name = "simple-ts-NAT-gw-1b"
  }
}

resource "aws_route_table" "private_rt_1a" {
  vpc_id = var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw_1a.id
  }

  tags = {
    Name = "simple-ts-private-rt-1a"
  }
}

resource "aws_route_table" "private_rt_1b" {
  vpc_id = var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw_1b.id
  }

  tags = {
    Name = "simple-ts-private-rt-1b"
  }
}

resource "aws_route_table_association" "private1a_subnet_assoc" {
  subnet_id      = aws_subnet.private1_subnet_us_east_1a.id
  route_table_id = aws_route_table.private_rt_1a.id
}

resource "aws_route_table_association" "private1b_subnet_assoc" {
  subnet_id      = aws_subnet.private2_subnet_us_east_1b.id
  route_table_id = aws_route_table.private_rt_1b.id
}
