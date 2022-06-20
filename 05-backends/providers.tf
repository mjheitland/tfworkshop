terraform {
  backend "local" {}

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  backend "s3" {
    encrypt = true
    key     = "myproject/state.tf"
    # dynamodb_table = "terraform-lock"
  }
}

provider "aws" {
  default_tags {
    tags = {
      example          = "aws/storage/basic"
      "ops/managed-by" = "terraform"
    }
  }
}
