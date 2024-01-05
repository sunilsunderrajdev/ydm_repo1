#!/bin/bash

exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

yum update -y
yum install -y httpd git
git clone https://github.com/gabrielecirulli/2048.git
cp -R 2048/* /var/www/html/
systemctl start httpd && systemctl enable httpd

echo "Hello from SSR !!!"
