resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "Project YDM"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "Internet Gateway"
  }
}

resource "aws_eip" "nat_eip" {
  count      = length(var.vpc_cidrs_public)
  vpc        = true
  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name = "NAT EIP ${count.index + 1}"
  }
}

/* Public subnets */
resource "aws_subnet" "public_subnets" {
  count                   = length(var.vpc_cidrs_public)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = element(var.vpc_cidrs_public, count.index)
  availability_zone_id    = element(["use1-az1"], count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet ${count.index + 1}"
  }
}

/* Routing table for public subnet */
resource "aws_route_table" "public_routes" {
  count   = length(var.vpc_cidrs_public)
  vpc_id  = aws_vpc.vpc.id

  tags = {
    Name = "Public route table ${count.index + 1}"
  }
}

resource "aws_route" "public_internet_gateway" {
  count                  = length(var.vpc_cidrs_public)
  route_table_id         = element(aws_route_table.public_routes.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

/* Route table associations for public subnet */
resource "aws_route_table_association" "public_route_table_association" {
  count          = length(var.vpc_cidrs_public)
  subnet_id      = element(aws_subnet.public_subnets.*.id, count.index)
  route_table_id = element(aws_route_table.public_routes.*.id, count.index)
}

resource "aws_nat_gateway" "nats" {
  count         = length(var.vpc_cidrs_public)
  allocation_id = element(aws_eip.nat_eip.*.id, count.index)
  subnet_id     = element(aws_subnet.public_subnets.*.id, count.index)
  depends_on    = [aws_internet_gateway.igw]

  tags = {
    Name = "Public nat ${count.index + 1}"
  }
}

resource "aws_subnet" "private_subnets" {
  count                   = length(var.vpc_cidrs_private)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = element(var.vpc_cidrs_private, count.index)
  availability_zone_id    = element(["use1-az1"], count.index)
  map_public_ip_on_launch = false

  tags = {
    Name = "Private Subnet ${count.index + 1}"
  }
}

/* Routing table for private subnet */
resource "aws_route_table" "private_routes" {
  count  = length(var.vpc_cidrs_private)
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "Private route table ${count.index + 1}"
  }
}

resource "aws_route" "private_nat_gateway" {
  count                  = length(var.vpc_cidrs_private)
  route_table_id         = element(aws_route_table.private_routes.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.nats.*.id, count.index)
}

resource "aws_route_table_association" "private_route_table_association" {
  count          = length(var.vpc_cidrs_private)
  subnet_id      = element(aws_subnet.private_subnets.*.id, count.index)
  route_table_id = element(aws_route_table.private_routes.*.id, count.index)
}

