terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  backend "s3" {
    key = "30_storage.tfstate"
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
