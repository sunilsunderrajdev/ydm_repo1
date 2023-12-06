resource "aws_instance" "ec2ydm_public" {
    ami = "ami-0230bd60aa48260c6"
    instance_type = "t2.micro"

    subnet_id = "${element(aws_subnet.public_subnets.*.id, 0)}"
    vpc_security_group_ids = ["${aws_security_group.ssh-allowed.id}"]
    key_name = "EC2_key_pair"

    tags = {
        Name: "YDM EC2 in public subnet 1 - Bastion host"
    }

    depends_on = [aws_key_pair.EC2_key_pair]
}

# KeyPair
#resource "aws_key_pair" "EC2_key" {
#    key_name = "EC2_key"
#    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDWzQvvpG20KIIbMKaldBki0d81B60ePY4oK1GtEie+ejWqrSYPvkZa55SiKY4QBnqYUj+LBII4nJpoGjXOoSUSup4AmKtHQMz006SAOr5qjyctRKlps1ciKjju9419xIP5LzglFAqiQWplELJ3X4KjCNuo+gLe+MnUxGJg3GR/RxhFY8pFVeij2QqvxTatudH35yxH+tFFhpqPTLEDgmQoudyJxouR911RFofrr/zqZ4Nfv+567TXfqBK4KeoYGxg72Ci8K+WVUMAFLXgFbVmg+xdbkM/nuE6qzts0tjI6NNrpCX80HTY/YloxQdupmgbt3V7uuSv9FX3fk2+Nn+26/MKvJDDOSx7Re2KGwlzxg75bkGBTfr9E6DB/RzxDWO5jGno5S7B7djhPtHvyYgWGm14wvCLqYlEud6+5pUf/uNR8aZ73IlT1biQHcDiGF0H7P7XbZepEMvOflTf2ijGOXQTMaHjV565CNjGM/1mx9+lwqsYwLo0Fwjl4ApF3laU3VWksma1IXpXiqrrH8Py8Mi9Si/LmDfD77DUs/7kifp0EKTtduFVTsrFOQF0og8zLGKgL+gqB2QeG1KeaC/HFHkhpFfZUjpqqz1jEOtW265I2PFwTNeTmcTlYo1yTlBCSMjudAwZ6oNAwKKh/cSkm+jf+vJBEInUVZAkoOkktpw== shikh@SSRDROID"
#}

resource "tls_private_key" "EC2_private_key" {
    algorithm = "RSA"
    rsa_bits = 4096
}

resource "aws_key_pair" "EC2_key_pair" {
    key_name = "EC2_key_pair"
    public_key = tls_private_key.EC2_private_key.public_key_openssh
}

resource "local_file" "EC2_key" {
    content = tls_private_key.EC2_private_key.private_key_pem
    filename = "ec2key"
}
