resource "aws_vpc" "main" {
    cidr_block = "{var.vpc_cidr}"

    tages = {
        Name = "Project YDM"
    }
}