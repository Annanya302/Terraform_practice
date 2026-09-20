terraform {
  #terraform version requirement.
  required_version = ">=1.1.0"
  required_providers {
    #aws provider is used to create resources in AWS.
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    #random provider is used to generate a unique s3 bucket suffix.
    random = {
      source = "hashicorp/random"
    }
  }
}
