resource "aws_cloudwatch_log_group" "tfw_loggroup" {
  name = "tfw_loggroup"

  tags = {
    Environment = "dev"
    Application = "tfworkshop"
  }
}

variable "apps" {
  type = map(any)
  default = {
    "foo" = {
      "region" = "us-east-1",
    },
    "bar" = {
      "region" = "eu-west-1",
    },
    "baz" = {
      "region" = "ap-south-1",
    },
  }
}

resource "random_pet" "example" {
  for_each = var.apps
}
