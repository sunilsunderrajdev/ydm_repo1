resource "aws_subnet" "public_subnets" {
 count      = length(["10.0.1.0/24","10.0.2.0/24"])
 vpc_id     = aws_vpc.vpc.id
 cidr_block = element(["10.0.1.0/24","10.0.2.0/24"], count.index)
 availability_zone_id = element(["use1-az1"], count.index)
 
 tags = {
   Name = "Public Subnet ${count.index + 1}"
 }
}
 
resource "aws_subnet" "private_subnets" {
 count      = length(["10.0.3.0/24","10.0.4.0/24"])
 vpc_id     = aws_vpc.vpc.id
 cidr_block = element(["10.0.3.0/24","10.0.4.0/24"], count.index)
 availability_zone_id = element(["use1-az1"], count.index)
 
 tags = {
   Name = "Observability Private Subnet ${count.index + 1}"
 }
}