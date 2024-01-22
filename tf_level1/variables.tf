variable "region" {
  type    = string
  default = "us-east-1"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "vpc_cidrs_public" {
  type        = list(string)
  description = "Public Subnet CIDRs"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "vpc_cidrs_private" {
  type        = list(string)
  description = "Private Subnet CIDRs"
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}
