variable "region" {
  type    = string
}

variable "vpc_cidr" {
  type    = string
}

variable "vpc_cidrs_public" {
  type        = list(string)
  description = "Public Subnet CIDRs"
}

variable "vpc_cidrs_private" {
  type        = list(string)
  description = "Private Subnet CIDRs"
}

variable "env_code" {
  type    = string
}