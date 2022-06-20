variable "region" {
  description = "AWS region we are deploying to"
  type        = string
  default     = "eu-west-1"
}

variable "bucket_name" {
  description = "Unique S3 bucket name (use only '-' and alphanumerical characters; must be globally unique)"
  type        = string
}

variable "kms_key_id" {
  description = "KMS key to encrypt the bucket"
  type        = string
  default     = null
}

resource "aws_s3_bucket_versioning" "bucket" {
  bucket = aws_s3_bucket.mybucket.id
  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.mybucket.id
  acl    = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_encryption" {
  bucket = aws_s3_bucket.mybucket.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_key_id != null ? var.kms_key_id : null
      sse_algorithm     = var.kms_key_id == null ? "AES256" : "aws:kms"
    }
  }
}

resource "aws_s3_bucket" "mybucket" {
  bucket = var.bucket_name

  # A boolean that indicates all objects (including any locked objects) should be deleted from the bucket
  # so that the bucket can be destroyed without error. These objects are not recoverable.
  force_destroy = true

  # prevent accidental deletion of this bucket
  # (if you really have to destroy this bucket, change this value to false and reapply, then run destroy)
  lifecycle {
    prevent_destroy = false
  }
}

output "output_s3_bucket_arn" {
  value       = aws_s3_bucket.mybucket.arn
  description = "The arn of the s3 bucket that stores terraform's remote state"
}
