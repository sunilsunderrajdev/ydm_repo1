resource "aws_vpc" "vpc" {
    cidr_block = "10.0.0.0/16"
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
  vpc        = true
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "nat" {
  allocation_id = "${aws_eip.nat_eip.id}"
  subnet_id     = "${element(aws_subnet.public_subnets.*.id, 0)}"
  depends_on    = [aws_internet_gateway.igw]
  tags = {
    Name        = "Public nat"
  }
}

resource "aws_subnet" "public_subnets" {
 count      = length(["10.0.1.0/24","10.0.2.0/24"])
 vpc_id     = aws_vpc.vpc.id
 cidr_block = element(["10.0.1.0/24","10.0.2.0/24"], count.index)
 availability_zone_id = element(["use1-az1"], count.index)
 map_public_ip_on_launch = true
 
 tags = {
   Name = "Public Subnet ${count.index + 1}"
 }
}

resource "aws_subnet" "private_subnets" {
 count      = length(["10.0.3.0/24","10.0.4.0/24"])
 vpc_id     = aws_vpc.vpc.id
 cidr_block = element(["10.0.3.0/24","10.0.4.0/24"], count.index)
 availability_zone_id = element(["use1-az1"], count.index)
 map_public_ip_on_launch = false
 
 tags = {
   Name = "Private Subnet ${count.index + 1}"
 }
}

/* Routing table for private subnet */
resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags = {
    Name        = "private-route-table"
  }
}
/* Routing table for public subnet */
resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags = {
    Name        = "public-route-table"
  }
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = "${aws_route_table.public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.igw.id}"
}

resource "aws_route" "private_nat_gateway" {
  route_table_id         = "${aws_route_table.private.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${aws_nat_gateway.nat.id}"
}

/* Route table associations */
resource "aws_route_table_association" "public" {
  count          = "${length(["10.0.1.0/24","10.0.2.0/24"])}"
  subnet_id      = "${element(aws_subnet.public_subnets.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "private" {
  count          = "${length(["10.0.3.0/24","10.0.4.0/24"])}"
  subnet_id      = "${element(aws_subnet.private_subnets.*.id, count.index)}"
  route_table_id = "${aws_route_table.private.id}"
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