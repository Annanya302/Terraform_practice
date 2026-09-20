#current workspace
output "workspace" {
  value = terraform.workspace
}

#environment
output "environment" {
  value = var.environment
}

#region
output "region" {
  value = data.aws_region.current_reg.name
}

#availability_zone
output "az" {
  description = "Availability zones used by the VPC"
  value       = module.vpc.az
}

#vpc id
output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}
#subnet id
output "subnet_ids" {
  description = "IDs of all public subnets"
  value       = module.vpc.subnet_ids
}

#security group id
output "security_group_id" {
  value = aws_security_group.webSG.id
}

#inbound port
output "inbound_port" {
  value = var.inbound_port
}

#ec2 instance
output "ec2-instance_ips" {
  value = aws_instance.webEc2[*].public_ip
}

#s3 bucket
output "s3_bucket_name" {
  value = aws_s3_bucket.main.bucket
}
