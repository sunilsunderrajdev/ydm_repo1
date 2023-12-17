resource "aws_instance" "ec2ydm_private" {
    ami = "ami-0230bd60aa48260c6"
    instance_type = "t2.micro"

    subnet_id = "${element(aws_subnet.private_subnets.*.id, 0)}"
    vpc_security_group_ids = ["${aws_security_group.ssh-allowed.id}"]
    key_name = "EC2_key_pair_private_AWS"

    tags = {
        Name: "YDM EC2 in private subnet 1"
    }
}

resource "aws_instance" "ec2ydm_public" {
    ami = "ami-0230bd60aa48260c6"
    instance_type = "t2.micro"

    subnet_id = "${element(aws_subnet.public_subnets.*.id, 0)}"
    vpc_security_group_ids = ["${aws_security_group.ssh-allowed.id}"]
    key_name = "EC2_key_pair_bastion_AWS"

    tags = {
        Name: "YDM EC2 in public subnet 1 - Bastion host"
    }
}
