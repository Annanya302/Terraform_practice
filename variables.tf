#project name
variable "project_name" {
  description = "Name of project"
  type        = string
}

#aws Region
variable "aws_region" {
  description = "AWS region for the environment"
  type        = string
}

#VPC CIDR block
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

#ec2 instance type
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

#number of ec2 instance
variable "instance_count" {
  description = "Number of EC2 instances to create"
  type        = number
}

#s3 versioning
variable "s3_versioning" {
  description = "Whether S3 bucket versioning should be enabled"
  type        = bool
}

#environment name
variable "environment" {
  description = "environment name"
  type        = string
  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "Environment must be one of: dev,prod."
  }
}


#allowed ip address for ssh access
variable "allowed_ip" {
  description = "ip address allowed to access the ec2 instance via ssh"
  type        = string
}

#Iam role name
variable "terraform_role_arn" {
  description = "ARN of the IAM role used by Terraform"
  type        = string
}



