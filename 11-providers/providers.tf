terraform {
  backend "local" {}

  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
  default_tags {
    tags = {
      example          = "aws/storage/basic"
      "ops/managed-by" = "terraform"
    }
  }
}

provider "aws" {
  alias = "us"
  region = "us-west-2"
  default_tags {
    tags = {
      example          = "aws/storage/basic"
      "ops/managed-by" = "terraform"
    }
  }
}
