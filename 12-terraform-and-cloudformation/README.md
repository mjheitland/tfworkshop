# Create S3 bucket

* cfn: using CloudFormation

```bash
aws cloudformation deploy --template-file s3.yaml --stack-name cfn --parameter-overrides "BucketNameParameter=heitlm-cfn" --capabilities CAPABILITY_IAM
```

* tf: using Terraform

```terraform
terraform init
terraform deploy
```

* tf_with_cfn: using Terraform calling a CloudFormation stack

```terraform
terraform init
terraform deploy
```

* cfn_with_tf: using CloudFormation calling a Terraform stack (works only if you run a TF server and install Cloudsoft's Terraform connector) [Installation guide](https://github.com/cloudsoft/aws-cfn-connector-for-terraform/blob/master/doc/installation-guide.md)
