data "aws_ami" "amazonlinux" {
  most_recent = true

  filter {
    name = "name"
    values = ["amzn2-ami-kernel-*"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["137112412989"]
}

resource "aws_instance" "ec2ydm_private" {
  ami                    = data.aws_ami.amazonlinux.id
  instance_type          = var.ec2_instance_type
  subnet_id              = data.terraform_remote_state.level1.outputs.private_subnet_id[1]
  vpc_security_group_ids = ["${aws_security_group.ssh-allowed.id}"]
  key_name               = "EC2_key_pair_private_AWS"
  user_data              = file("user-data.sh")

  tags = {
    Name : "YDM EC2 in private subnet"
  }
}

resource "aws_instance" "ec2ydm_public" {
  ami                         = data.aws_ami.amazonlinux.id
  associate_public_ip_address = true
  instance_type               = var.ec2_instance_type
  subnet_id                   = data.terraform_remote_state.level1.outputs.public_subnet_id[1]
  vpc_security_group_ids      = ["${aws_security_group.ssh-allowed.id}"]
  key_name                    = "EC2_key_pair_bastion_AWS"

  tags = {
    Name : "YDM EC2 in public subnet - Bastion host"
  }
}

resource "aws_security_group" "ssh-allowed" {
  name        = "vpc-allow-ssh"
  description = "Default security group to allow inbound/outbound from the VPC"
  vpc_id      = data.terraform_remote_state.level1.outputs.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH from public"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP from public"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP from Load Balancer"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.load_balancer.id]
  }

  tags = {
    Name = "ssh-allowed"
  }
}
