resource "aws_instance" "ec2ydm_public" {
    ami = "ami-0230bd60aa48260c6"
    instance_type = "t2.micro"

    subnet_id = "${element(aws_subnet.public_subnets.*.id, 0)}"
    vpc_security_group_ids = ["${aws_security_group.ssh-allowed.id}"]
    key_name = "EC2_key"

    tags = {
        Name: "YDM EC2 in public subnet 1 - Bastion host"
    }
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.ec2ydm_public.id
  allocation_id = aws_eip.nat_eip.id
}

# KeyPair
resource "aws_key_pair" "EC2_key" {
    key_name = "EC2_key"
    public_key = tls_private_key.rsa4096.public_key_openssh
}

resource "tls_private_key" "rsa4096" {
    algorithm = "RSA"
    rsa_bits = 4096
}

output "private_key" {
  value     = tls_private_key.rsa4096.private_key_pem
  sensitive = true
}