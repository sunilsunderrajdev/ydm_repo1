data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source              = "terraform-aws-modules/vpc/aws"
  name                = "main-vpc"
  cidr                = var.vpc_cidr
  azs                 = data.aws_availability_zones.available.names[*]
  private_subnets     = var.vpc_cidrs_private
  public_subnets      = var.vpc_cidrs_public
  enable_nat_gateway = true
}
