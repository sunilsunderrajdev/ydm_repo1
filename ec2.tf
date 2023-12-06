resource "aws_instance" "ec2ydm_private" {
    ami = "ami-0230bd60aa48260c6"
    instance_type = "t2.micro"

    subnet_id = "${element(aws_subnet.private_subnets.*.id, 0)}"
    vpc_security_group_ids = ["${aws_security_group.ssh-allowed.id}"]

    tags = {
        Name: "YDM EC2 in private subnet 1"
    }

    depends_on = [aws_key_pair.EC2_key_pair_bastion]
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

resource "aws_key_pair" "EC2_key_pair_bastion" {
    key_name = "EC2_key_pair_bastion"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCmkm4M7pgDMhb8z7GKFl2SDBwoe8AiMaJ19H1y+L2s7hNCqhnfkoykv9vqBBdHkCHOIfHd7Zz0B3qIsI4RrOSanXDWsoV4WBOfIXvIAbVOk3BIA4bDQoh3OfPawIrvYceNPun05F106vqho69iBBe6PmoOT9YTTTKYy5cUhAYefGN/npB4lrOgl59s0GUHmhBUvt30tAkXbH/Rn4WjH6Ulmzsjn0xUZDR9r6PSpU+s2vK18h6z76ZJap1BpmLtdSE85SrZdRAeaySR695O++Dx3sLD20EbzpDnrnj6kVh5brbMRXaI9a9pdqUFOqVRyOiajYDAAVSI/hDytdKROw3peRhtXYNT1bXXQwizq/GG8vr5nFEEsUjMNxI7UX9RPAHzbXu1ssKhVxskXQ+Dt+MNCFOa+7EQLt96QB2NRWeLicyUx+7k06z8dXHgPzhzl0ToyISASXIXC0jr6VYofpSgrJdtmDjCHJXsDSTw3lCDUS+zDuv9jtcK20KXc5oQgE0= ec2-user@ip-10-0-1-70.ec2.internal"
}