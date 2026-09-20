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
output "availability_zone" {
  value = data.aws_availability_zones.availableAZ.names[0]
}

#vpc id
output "vpc_id" {
  value = module.vpc.vpc_id
}

#subnet id
output "subnet_id" {
  value = module.vpc.aws_subnet_id
}

#security group id
output "security_group_id" {
  value = aws_security_group.webSG.id
}

#ec2 instance
output "ec2-instance_ips" {
  value = aws_instance.webEc2[*].public_ip
}

#s3 bucket
output "s3_bucket_name" {
  value = aws_s3_bucket.main.bucket
}
