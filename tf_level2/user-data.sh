#!/bin/bash

exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

yum update -y
yum install -y httpd git
git clone https://github.com/gabrielecirulli/2048.git
cp -R 2048/* /var/www/html/
systemctl start httpd && systemctl enable httpd

#yum remove awscli
#curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
#unzip awscliv2.zip
#./aws/install

echo "Hello from SSR !!!!!"
