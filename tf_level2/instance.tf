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
  count                  = 2
  ami                    = data.aws_ami.amazonlinux.id
  instance_type          = var.ec2_instance_type
  subnet_id              = element(data.terraform_remote_state.level1.outputs.private_subnet_id, count.index)
  vpc_security_group_ids = ["${aws_security_group.ssh-allowed.id}"]
  key_name               = "EC2_key_pair_private_AWS"

  tags = {
    Name : "YDM EC2 ${count.index + 1} in private subnet"
  }
}

resource "aws_instance" "ec2ydm_public" {
  count                  = 2
  ami                    = data.aws_ami.amazonlinux.id
  instance_type          = var.ec2_instance_type
  subnet_id              = element(data.terraform_remote_state.level1.outputs.public_subnet_id, count.index)
  vpc_security_group_ids = ["${aws_security_group.ssh-allowed.id}"]
  key_name               = "EC2_key_pair_bastion_AWS"
  user_data              = file("user-data.sh")

  tags = {
    Name : "YDM EC2 ${count.index + 1} in public subnet - Bastion host"
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

  tags = {
    Name = "ssh-allowed"
  }
}