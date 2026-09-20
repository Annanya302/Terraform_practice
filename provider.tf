provider "aws" {
  #aws region comes from the selected environment's tfvars file.
  region = var.aws_region

  #terraform assumes this role to get permission to create and manage aws infrastructure resources.
  assume_role {
    role_arn = "arn:aws:iam::856121136436:role/TerraformRole"
  }
}
