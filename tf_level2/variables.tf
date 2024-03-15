variable "region" {
  type    = string
}

variable "env_code" {
  type    = string
}

variable "ec2_ami" {
  type        = string
  description = "EC2 AMI"
}

variable "ec2_instance_type" {
  type        = string
  description = "EC2 Instance Type"
}

variable "hosted_zone" {
  type        = string
  description = "Website name"
}

variable "domain" {
  type        = string
  description = "Website domain"
}
