output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnet_id" {
  value = aws_subnet.public_subnets.*.id
}

output "private_subnet_id" {
  value = aws_subnet.private_subnets.*.id
}

output "vpc_cidrs_public" {
  value = var.vpc_cidrs_public
}

output "vpc_cidrs_private" {
  value = var.vpc_cidrs_private
}

output "vpc_cidr" {
  value = var.vpc_cidr
}
