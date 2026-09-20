# VPC CIDR supplied by the root configuration.
variable "vpc_cidr" {
  type = string
}
# Name supplied by the root configuration.
variable "name" {
  type = string
}

# Availability Zone supplied by the root configuration.
variable "availability_zones" {
  type = list(string)
}

#subnet count supplied by the root configuration.
variable "subnet_count" {
  description = "Number of subnets to create"
  type        = number
}
