#----------------------------------------------------------
#  Terraform - From Zero to Certified Professional
#
# Build WebServer during Bootstrap
#
# Made by Denis Astahov
#----------------------------------------------------------

provider "aws" {
  region = "ap-south-1"
}

resource "aws_default_vpc" "default" {} # This need to be added since AWS Provider v4.29+ to get VPC id

resource "aws_instance" "web" {
  ami                         = "ami-0aee0743bf2e81172" // Amazon Linux2
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.web.id]
  user_data_replace_on_change = true   # This need to added!!!! 
  user_data                   = <<EOF
#!/bin/bash
yum -y update
yum -y install httpd
echo "This talaiva Built by Terraform" > /var/www/html/index.html
service httpd start
chkconfig httpd on
EOF
  tags = {
    Name  = "WebServer Built by Terraform"
    Owner = "Avisek"
  }
}

resource "aws_security_group" "web" {
  name        = "WebServer-SG"
  description = "Security Group for my WebServer"
  vpc_id      = aws_default_vpc.default.id # This need to be added since AWS Provider v4.29+ to set VPC id

  ingress {
    description = "Allow port HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow port HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow ALL ports"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "WebServer SG by Terraform"
    Owner = "Avisek"
  }
}
