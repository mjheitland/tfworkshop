resource "aws_cloudwatch_log_group" "secret_rotation" {
  name = "/aws/lambda/secret_rotation"

  # retention_in_days = 28
}

# tfsec:ignore:aws-s3-enable-bucket-encryption tfsec:ignore:aws-s3-enable-bucket-logging tfsec:ignore:aws-s3-block-public-acls tfsec:ignore:aws-s3-block-public-policy
resource "aws_s3_bucket" "my-bucket" {
  bucket = "foobar"
}

resource "aws_security_group_rule" "my-rule" {
    type = "ingress"
    cidr_blocks = ["0.0.0.0/0"] #tfsec:ignore:aws-vpc-no-public-ingress-sgr
}