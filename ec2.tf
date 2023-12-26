resource "aws_instance" "ec2ydm_private" {
  count                  = 2
  ami                    = var.ec2_ami
  instance_type          = var.ec2_instance_type
  subnet_id              = element(aws_subnet.private_subnets.*.id, 0)
  vpc_security_group_ids = ["${aws_security_group.ssh-allowed.id}"]
  key_name               = "EC2_key_pair_private_AWS"

  tags = {
    Name : "YDM EC2 ${count.index + 1} in private subnet"
  }
}

resource "aws_instance" "ec2ydm_public" {
  count                  = 2
  ami                    = var.ec2_ami
  instance_type          = var.ec2_instance_type
  subnet_id              = element(aws_subnet.public_subnets.*.id, 0)
  vpc_security_group_ids = ["${aws_security_group.ssh-allowed.id}"]
  key_name               = "EC2_key_pair_bastion_AWS"

  tags = {
    Name : "YDM EC2 ${count.index + 1} in public subnet - Bastion host"
  }
}
