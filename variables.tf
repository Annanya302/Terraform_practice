
variable "project_name" {
  description = "Name of project"
  type        = string
}

variable "aws_region" {
  description = "AWS region for the environment"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "instance_count" {
  description = "Number of EC2 instances to create"
  type        = number
}

variable "s3_versioning" {
  description = "Whether S3 bucket versioning should be enabled"
  type        = bool
}

variable "environment" {
  description = "environment name"
  type        = string
  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "Environment must be one of: dev,prod."
  }
}

variable "allowed_ip" {
  description = "ip address allowed to access the ec2 instance"
  type        = string
}

variable "inbound_port" {
  description = "Inbound port allowed by the security group"
  type        = number
}





