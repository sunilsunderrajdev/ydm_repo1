resource "aws_security_group" "private" {
  name        = "vpc-allow-ssh"
  description = "Default security group to allow inbound/outbound from the VPC"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description     = "HTTP from Load Balancer"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [var.load_balancer_sg]
  }

  tags = {
    Name = "Private"
  }
}
