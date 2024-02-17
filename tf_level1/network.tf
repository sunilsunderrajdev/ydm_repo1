module "vpc" {
  source = "../modules/vpc"

  region            = var.region
  env_code          = var.env_code
  vpc_cidr          = var.vpc_cidr
  vpc_cidrs_private = var.vpc_cidrs_private
  vpc_cidrs_public  = var.vpc_cidrs_public
}
