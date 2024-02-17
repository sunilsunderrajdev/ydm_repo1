variable "env_code" {
  type    = string
}

variable "ec2_instance_type" {
  type        = string
  description = "EC2 Instance Type"
}

variable "private_subnet_id" {}

variable "vpc_id" {}

variable "load_balancer_sg" {}

variable "target_group_arn" {}
