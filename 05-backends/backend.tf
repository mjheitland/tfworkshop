terraform {
  backend "s3" {
    encrypt = true
    key     = "myproject/state.tf"
  }
}
