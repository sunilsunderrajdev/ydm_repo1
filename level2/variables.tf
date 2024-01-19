variable "region" {
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

