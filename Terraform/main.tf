terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# KMS Key for EBS Encryption
resource "aws_kms_key" "ebs_key" {
  description             = "EBS encryption key"
  deletion_window_in_days = 7
  enable_key_rotation     = true
}

# Dynamic AMI lookup
data "aws_ami" "dyn_AMI_c" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}

# EC2 Instance
resource "aws_instance" "app_server" {
  ami                    = data.aws_ami.dyn_AMI_c.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  user_data              = filebase64("${path.module}/user_data.sh")
# key_name               = "smallcase"

  tags = {
    Name = "PythonAppServer"
  }
}

# EBS Volume with KMS
resource "aws_ebs_volume" "app_volume" {
  availability_zone = aws_instance.app_server.availability_zone
  size              = var.volume_size
  encrypted         = true
  kms_key_id        = aws_kms_key.ebs_key.arn

  tags = {
    Name = "EncryptedAppVolume"
  }
}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdk"
  volume_id   = aws_ebs_volume.app_volume.id
  instance_id = aws_instance.app_server.id
}

# Security Group
resource "aws_security_group" "app_sg" {
  name = "app-sg"

#  ingress {
#    from_port   = 22
#    to_port     = 22
#    protocol    = "tcp"
#    cidr_blocks = ["0.0.0.0/0"]
# }

  ingress {
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Elastic IP
resource "aws_eip" "app_eip" {
  instance = aws_instance.app_server.id
  domain = "vpc"
}
