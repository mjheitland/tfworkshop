locals {
  workspaces = {
    dev = {
      primary_vpc_id    = "vpc-11111111111111111"
      region            = "eu-west-1"
      secondary_regions = ["eu-central-1"]
      secondary1_vpc_id = "vpc-33333333333333333"
    }
    prod = {
      primary_vpc_id    = "vpc-22222222222222222"
      region            = "eu-west-1"
      secondary_regions = ["eu-central-1"]
      secondary1_vpc_id = "vpc-33333333333333333"
    }
    proddr = {
      primary_vpc_id    = "vpc-33333333333333333"
      region            = "eu-central-1"
      secondary_regions = ["eu-west-1"]
      secondary1_vpc_id = "vpc-22222222222222222"
    }
  }

  workspace = local.workspaces[terraform.workspace]

  # usage: local.workspace.primary_vpc_id
}

output "workspace" {
  value = local.workspace
}