resource "aws_instance" "ec2ydm" {
    ami = "ami-0230bd60aa48260c6"
    instance_type = "t2.micro"

    subnet_id = "Private Subnet 1"
    user_data = <<EOF
#!/bin/bash
echo "Copying the SSH Key to the server"
echo -e "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCs9NRkwo4EhyqYNk/hd7FwAFBr49TbgWAMq+arvBb7VTCe1+3WMwHE/B6Ur4CfSesUqST9sX1eGVr0gCwX5DPNQbgA/wiHHF2UDjdUW29PXOCLoaME52voUo45kzHNQxRxmqJkOLnUBlvKg8AvDk5JOpl+FLgKv+b0pB3gf/L+JA9swKC1SaQVO+QdcdT4OztXCqJum+2BykBnutIBMXPD2tNOCLIZAhRRXr0dQJSO85lrEFuTznNzymTvi00UsR5gd9v/QzAffUeUKyxshDx+XReo/OiQi1o8EYeMohseM/nKlTfFpsXxSETxG3xhRz/FtfDGFYE6RpLcBRC8xRGlmXnb1CejFD/M6nSP4EK4aiWc9C0B9be4B2IKN66f1FB8jlXmPOH0a4iEfROi4lQ9s9jRuKsPb//qLcH7gPKn58nUx+IDzJkekcrHfR4RJf74KVLQoH+JODzJ1c3C18SZsn6S1hAV/NwLoDLJPUaBFolRl67kxwoS3W3fku+0SCYQ/8Nh7i5lodMMK+rX9uigN53M1UZlY7ljlx3JpMu1z18Le0SmUJ3niLvtmiWc/4eUOp5CrDa1kTPaoGaU7Nafy4/ijEcn8AgzYSSK2YotRm0fC5Zn2+YLe1dDpUoLn9ydD6BZlqLdopXCbv5rz/hF9jm2xRkeNIru9xbcjA6g3Q== shikh@SSRDROID" >> /home/ubuntu/.ssh/authorized_keys
EOF
    vpc_security_group_ids = ["${aws_security_group.ssh-allowed.id}"]

    tags = {
        Name: "YDM EC2"
    }
}