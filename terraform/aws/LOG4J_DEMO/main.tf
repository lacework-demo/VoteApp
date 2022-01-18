variable "AWS_REGION" {
  description = "AWS region.  Example: us-east-2"
}

variable "DEPLOYMENT_NAME" {
  description = "Name of deployment - used for the cluster name.  Example: rotate"
}

variable "LACEWORK_ACCESS_TOKEN" {
  description = "Lace work Access Token"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.20.0"
    }

    local = {
      source  = "hashicorp/local"
      version = "2.1.0"
    }

    null = {
      source  = "hashicorp/null"
      version = "3.1.0"
    }
  }
  required_version = "> 0.14"
}

provider "aws" {
  region = var.AWS_REGION
}

locals {
  instance_name_a = "ec2-log4j-${var.DEPLOYMENT_NAME}a"
  instance_name_b = "ec2-log4j-${var.DEPLOYMENT_NAME}b"
  instance_name_t = "ec2-log4j-${var.DEPLOYMENT_NAME}-traffic"
}

data "aws_ami" "ubuntu" {
    most_recent = true
    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }
    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }
    owners = ["099720109477"] # Canonical
}

resource "aws_security_group" "log4jsecuritygroup" {
  name = "log4jsecuritygroup"
  description = "Log4J security group"
}

resource "aws_security_group_rule" "log4j-private-port-ingress" {
    type = "ingress"
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["${aws_instance.traffic.public_ip}/32"]
    security_group_id = "${aws_security_group.log4jsecuritygroup.id}"
}

resource "aws_security_group_rule" "log4j-private-port-ingress-ssh" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = "${aws_security_group.log4jsecuritygroup.id}"
}

resource "aws_security_group_rule" "log4j-private-port-egress" {
    type = "egress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = "${aws_security_group.log4jsecuritygroup.id}"
}

resource "aws_instance" "log4jhosta" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name = "godev_us_west_1"

  tags = {
    Name = local.instance_name_a
  }
  user_data = "${templatefile("./vm-setup-script.sh",
                {
                   "HOST_A_B"="A",
                   "LACEWORK_ACCESS_TOKEN"=var.LACEWORK_ACCESS_TOKEN
                }
              )}"
  vpc_security_group_ids = [aws_security_group.log4jsecuritygroup.id]
}

resource "aws_instance" "log4jhostb" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.small"
  key_name = "godev_us_west_1"

  tags = {
    Name = local.instance_name_b
  }
  user_data = "${templatefile("./vm-setup-script.sh",
                {
                   "HOST_A_B"="B",
                   "LACEWORK_ACCESS_TOKEN"=var.LACEWORK_ACCESS_TOKEN
                }
              )}"
  vpc_security_group_ids = [aws_security_group.log4jsecuritygroup.id]
}

resource "aws_instance" "traffic" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name = "godev_us_west_1"

  tags = {
    Name = local.instance_name_t
  }
  user_data = "${templatefile("./traffic-setup-script.sh",{
                "IP_A"=aws_instance.log4jhosta.public_ip,
                "IP_B"=aws_instance.log4jhostb.public_ip
  })}"
}
