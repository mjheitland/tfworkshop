# Backend Configuration

A backend defines where Terraform stores its state data files.

Terraform uses persisted state data to keep track of the resources it manages. Most non-trivial Terraform configurations either integrate with Terraform Cloud or use a backend to store state remotely. This lets multiple people access the state data and work together on that collection of infrastructure resources.

By default, Terraform uses a backend called local, which stores state as a local file on disk. You can also configure one of the built-in backends. Some of these backends act like plain remote disks for state files, while others support locking the state while operations are being performed. One common option is using an S3 bucket.

You do not need to configure a backend when using Terraform Cloud because Terraform Cloud automatically manages state in the workspaces associated with your configuration.

```terraform
terraform init -backend-config="backends\backend-dev-eu-west-1.tfvars"
```

**Important: protect state bucket, it contains sensitive information!**

## Using a DynamoDB table for state locking

Create DynamoDB locking table:

```terraform
resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = "terraform-lock"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}
```

Add permissions for GetItem, PutItem, DeleteItem):

Add table to backend configuration:

```terraform
terraform {
  backend "s3" {
    bucket = "terraformbackend"
    key = "terraform"
    region = "us-east-2"
    dynamodb_table = "terraform-lock"
  }
}
```
