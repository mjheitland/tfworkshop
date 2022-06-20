# access remote state of 10_network
data "terraform_remote_state" "tf_network" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "10_network.tfstate"
    region = var.region
  }
}

# access remote state of tf_security
data "terraform_remote_state" "20_security" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "20_security.tfstate"
    region = var.region
  }
}

resource "..." "fsx" {
  subnetId1 = data.terraform_remote_state.tf_network.outputs.subpub1_id
  subnetId2 = data.terraform_remote_state.tf_network.outputs.subpub2_id

  sgId = data.terraform_remote_state.tf_security.outputs.sgpub1_id
  # ...
}
