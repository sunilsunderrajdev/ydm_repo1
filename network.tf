resource "aws_vpc" "vpc" {
    cidr_block              = var.vpc_cidr
    enable_dns_hostnames    = true
    enable_dns_support      = true

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
  vpc        = true
  depends_on = [aws_internet_gateway.igw]
}

/* Public subnets */
resource "aws_subnet" "public_subnets" {
 count                    = length(var.vpc_cidrs_public)
 vpc_id                   = aws_vpc.vpc.id
 cidr_block               = element(var.vpc_cidrs_public, count.index)
 availability_zone_id     = element(["use1-az1"], count.index)
 map_public_ip_on_launch  = true
 
 tags = {
   Name = "Public Subnet ${count.index + 1}"
 }
}

/* Routing table for public subnet */
resource "aws_route_table" "public_route" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags = {
    Name        = "public-route-table"
  }
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = "${aws_route_table.public_route.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.igw.id}"
}

/* Route table associations for public subnet */
resource "aws_route_table_association" "public" {
  count          = "${length(var.vpc_cidrs_public)}"
  subnet_id      = "${element(aws_subnet.public_subnets.*.id, count.index)}"
  route_table_id = "${aws_route_table.public_route.id}"
}

resource "aws_nat_gateway" "nats" {
  count         = length(var.vpc_cidrs_public)
  allocation_id = "${aws_eip.nat_eip.id}"
  subnet_id     = "${element(aws_subnet.public_subnets.*.id, count)}"
  depends_on    = [aws_internet_gateway.igw]
  tags = {
    Name        = "Public nat ${count.index + 1}"
  }
}

resource "aws_subnet" "private_subnets" {
 count                    = length(var.vpc_cidrs_private)
 vpc_id                   = aws_vpc.vpc.id
 cidr_block               = element(var.vpc_cidrs_private, count.index)
 availability_zone_id     = element(["use1-az1"], count.index)
 map_public_ip_on_launch  = false
 
 tags = {
   Name = "Private Subnet ${count.index + 1}"
 }
}

/* Routing table for private subnet */
resource "aws_route_table" "private_routes" {
  count         = length(var.vpc_cidrs_private)
  vpc_id        = "${aws_vpc.vpc.id}"
  tags = {
    Name        = "private-route-table ${count.index + 1}"
  }
}

resource "aws_route" "private_nat_gateway" {
  count                   = length(var.vpc_cidrs_private)
  route_table_id          = "${element(aws_route_table.private_routes.*.id, count.index)}"
  destination_cidr_block  = "0.0.0.0/0"
  nat_gateway_id          = "${element(aws_nat_gateway.nats.*.id, count.index)}"
}

resource "aws_route_table_association" "private" {
  count          = "${length(var.vpc_cidrs_private)}"
  subnet_id      = "${element(aws_subnet.private_subnets.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private_routes.*.id, count.index)}"
}

resource "aws_security_group" "ssh-allowed" {
  name        = "vpc-allow-ssh"
  description = "Default security group to allow inbound/outbound from the VPC"
  vpc_id = "${aws_vpc.vpc.id}"
  depends_on  = [aws_vpc.vpc]

  egress {
      from_port = 0
      to_port = 0
      protocol = -1
      cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
      Name = "ssh-allowed"
  }
}
