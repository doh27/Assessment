provider "aws" {
  region  = "us-east-1"
  profile = "noela-assessment"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  # backend "s3" {
  #   bucket = "noela-assessment-for-"
  #   key = "assessment/terraform.tfstate"
  #   profile = "noela-assessment"
  #   region = "us-east-1"
  #   dynamo_table = "noela-assessment-tf-state-lock"
  # }
}