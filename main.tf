#data source 1:AZ
data "aws_availability_zones" "availableAZ" {
  state = "available"
}

#data source 2: ami
data "aws_ssm_parameter" "ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}
data "aws_region" "current_reg" {
}

#local values
locals {
  resource_name = "${var.project_name}-${var.environment}"
}

#vpc module
module "vpc" {
  source       = "./modules/vpc"
  vpc_cidr     = var.vpc_cidr
  az           = data.aws_availability_zones.availableAZ.names
  name         = local.resource_name
  subnet_count = var.instance_count
}

#security group
resource "aws_security_group" "webSG" {
  vpc_id      = module.vpc.vpc_id
  description = "Allow inbound HTTP "
  ingress {
    description = "CIDR block allowed to access HTTP on the EC2 instance"
    from_port   = var.inbound_port
    to_port     = var.inbound_port
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ip]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name        = "${local.resource_name}-webSG"
    Environment = var.environment
  }
}

#ec2 instance
resource "aws_instance" "webEc2" {
  count                  = var.instance_count
  ami                    = data.aws_ssm_parameter.ami.value
  instance_type          = var.instance_type
  subnet_id              = module.vpc.subnet_ids[count.index]
  vpc_security_group_ids = [aws_security_group.webSG.id]
  tags = {
    Name        = "${local.resource_name}-ec2-${count.index + 1}"
    Environment = var.environment
    project     = var.project_name
  }
}

resource "random_id" "bucket_suffix" {
  byte_length = 4
}

#s3
resource "aws_s3_bucket" "main" {
  bucket = "${local.resource_name}-bucket-${random_id.bucket_suffix.hex}"
  tags = {
    Name        = "${local.resource_name}-bucket"
    Environment = var.environment
    project     = var.project_name

  }
}

#s3 versioning
resource "aws_s3_bucket_versioning" "main" {
  bucket = aws_s3_bucket.main.id
  versioning_configuration {
    status = var.s3_versioning ? "Enabled" : "Suspended"
  }
}

