#data source 1:AZ
data "aws_availability_zones" "availableAZ" {
  state = "available"
}

#data source 2: ami
data "aws_ssm_parameter" "ami" {
  # AWS Systems Manager provides the latest Amazon Linux 2023 AMI.
  # This avoids hardcoding an AMI ID.
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"

}

#data source 4: current region
data "aws_region" "current_reg" {
  # Gets the region configured in the AWS provider.
}

#local values
locals {
  # Workspace gives us the current Terraform environment
  workspace_environment = terraform.workspace

  # Create a common resource name.
  resource_name = var.project_name
}

#vpc module
module "vpc" {

  source = "./modules/vpc"

  vpc_cidr = var.vpc_cidr

  availability_zones = data.aws_availability_zones.availableAZ.names


  subnet_count = var.instance_count


  name = local.resource_name
}


#security group
resource "aws_security_group" "webSG" {
  #create sg inside the vpc created by our module
  vpc_id      = module.vpc.vpc_id
  description = "Allow inbound HTTP "

  # Allow HTTP traffic from the configured IP/CIDR
  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ip]
  }

  #allow outbound traffic
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


#s3
resource "aws_s3_bucket" "main" {
  # S3 bucket names must be globally unique.
  bucket = "${local.resource_name}-bucket-${random_id.bucket_suffix.hex}"
  tags = {
    Name        = "${local.resource_name}-bucket"
    Environment = var.environment
    project     = var.project_name

  }
}

resource "random_id" "bucket_suffix" {
  byte_length = 4
}

#s3 versioning
resource "aws_s3_bucket_versioning" "main" {
  bucket = aws_s3_bucket.main.id
  versioning_configuration {
    status = var.s3_versioning ? "Enabled" : "Suspended"
  }
}

