resource "aws_instance" "ec2ydm_private" {
    ami = "ami-0230bd60aa48260c6"
    instance_type = "t2.micro"

    subnet_id = "${element(aws_subnet.private_subnets.*.id, 0)}"
    vpc_security_group_ids = ["${aws_security_group.ssh-allowed.id}"]

    tags = {
        Name: "YDM EC2 in private subnet 1"
    }
}

resource "aws_instance" "ec2ydm_public" {
    ami = "ami-0230bd60aa48260c6"
    instance_type = "t2.micro"

    subnet_id = "${element(aws_subnet.public_subnets.*.id, 0)}"
    vpc_security_group_ids = ["${aws_security_group.ssh-allowed.id}"]
    key_name = "EC2_key_pair_nonaws"

    tags = {
        Name: "YDM EC2 in public subnet 1 - Bastion host"
    }

    depends_on = [aws_key_pair.EC2_key_pair_nonaws]
}

# KeyPair
resource "aws_key_pair" "EC2_key_pair_nonaws" {
    key_name = "EC2_key_pair_nonaws"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDGYsZQumFVfIvHlIS/UppkAhfu5N9vZ0kMFcZEviH3TXEgXZ5pChUPTWjcEhViq5MJhJS4UfvBNluPd3K8UGnnduaeRoZ9yURYp2Sy39EZvonVbj0zoi3SxpmKHif9u4f/Az8WxalBKRn8cz1+ALyeiJwZFSeVqfJ9Oz5KcwWUHibDP+QBd8zJcGVJjaosOuRgiCDK68lwDJcpzx0Rqxmj1HlyL8cJCshoPqnX8Tc8D1pDSPVGnbkbrXBcEAgBG+sFoVyqXxsn2CZ3FEwoBZegdsqOoucen8x3FwSKA1HxL0EbocklovO8xedBu0/GB57je265+EYrxKGdm1kwWSTT shikh@SSRDROID"
}

#resource "tls_private_key" "EC2_private_key" {
#    algorithm = "RSA"
#    rsa_bits = 4096
#}

#resource "aws_key_pair" "EC2_key_pair" {
#    key_name = "EC2_key_pair"
#    public_key = tls_private_key.EC2_private_key.public_key_openssh
#}

#resource "local_file" "EC2_key" {
#    content = tls_private_key.EC2_private_key.private_key_pem
#    filename = "ec2key"
#}
