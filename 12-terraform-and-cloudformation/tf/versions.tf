#--- 0_tfstate/config.tf ---

terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = ">= 3.0.0"
  }
}

provider "aws" {
}
