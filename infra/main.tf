terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "sa-east-1"
}

###################
# Security Groups #
###################
resource "aws_security_group" "ragzinho_ssh" {
  name        = "ragzinho_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = "vpc-98eaedff" # change this to your vpc id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ragzinho_internet" {
  name        = "ragzinho_internet"
  description = "Allow internet outbound traffic"
  vpc_id      = "vpc-98eaedff" # change this to your vpc id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ragzinho_play" {
  name        = "ragzinho_play"
  description = "Allow play outbound traffic"
  vpc_id      = "vpc-98eaedff" # change this to your vpc id

  ingress {
    from_port   = 6900
    to_port     = 6900
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 6900
    to_port     = 6900
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5121
    to_port     = 5121
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5121
    to_port     = 5121
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 6121
    to_port     = 6121
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 6121
    to_port     = 6121
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

###################
# Server Instance #
###################
resource "aws_instance" "ragzinho_server" {
  ami               = "ami-0deebba34ef22f5a9"
  instance_type     = "t2.micro"
  key_name          = "ragzinho" # change this to your keypair name
  security_groups   = ["ragzinho_ssh", "ragzinho_internet", "ragzinho_play"] # change this to the security group name
  user_data         = file("user_data.sh")
  availability_zone = "sa-east-1a"

  ebs_block_device {
    device_name           = "/dev/xvdf" 
    delete_on_termination = false
    volume_size           = "20"
    encrypted             = true
    # snapshot_id           = # set your snapshot here, must also remove the encrypted option
    tags = {
      Name = "ragzinho_server_ebs"
      FileSystem: "~/ragzinho"
    }
  }

  tags = {
    Name = "ragzinho_server"
  }
}

#######
# EIP #
#######
resource "aws_eip" "ragzinho_ip" {
  instance = aws_instance.ragzinho_server.id
  vpc      = true
}
