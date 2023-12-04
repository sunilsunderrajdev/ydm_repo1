resource "aws_instance" "ec2ydm" {
    ami = "ami-0230bd60aa48260c6"
    instance_type = "t2.micro"

    subnet_id = "Private Subnet 1"
    vpc_security_group_ids = ["${aws_security_group.ssh-allowed.id}"]
    key_name = "${aws_key_pair.us-region-key-pair.id}"

    tags = {
        Name: "YDM EC2"
    }
}

resource "aws_key_pair" "us-region-key-pair" {
    key_name = "us-region-key-pair"
    public_key = "~/.ssh/id_rsa.pub"
}