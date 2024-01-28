variable "region" {
  type    = string
  default = "us-east-1"
}

variable "env_code" {
  type    = string
  default = "main"
}

variable "ec2_ami" {
  type        = string
  description = "EC2 AMI"
  default     = "ami-0230bd60aa48260c6"
}

variable "ec2_instance_type" {
  type        = string
  description = "EC2 Instance Type"
  default     = "t2.micro"
}

