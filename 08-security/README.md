# Security

General rules:

* Do not store any secrets (tokens, credentials, connection strings etc.) in your Terraform code.
* Remember that Terraform's state file stores all secrets in plain text. Therefore state file should be encrypted and access restricted. Use different buckets for prod and nonprod environments.
* Use separate AWS accounts for production and non-production.
* Integrate security tools into your CICD pipeline, so that code will always be scanned for vulnerabilities on check-in.

## terraform validate

The terraform validate command validates the configuration files in a directory, referring only to the configuration and not accessing any remote services such as remote state, provider APIs, etc.

Validate runs checks that verify whether a configuration is syntactically valid and internally consistent, regardless of any provided variables or existing state. It is thus primarily useful for general verification of reusable modules, including correctness of attribute names and value types.

How to run:

```bash
terraform validate
```

## tflint

TFLint is a framework and each feature is provided by plugins, the key features are as follows:

* Find possible errors (like illegal instance types) for Major Cloud providers (AWS/Azure/GCP).
* Warn about deprecated syntax, unused declarations.
* Enforce best practices, naming conventions.

Installation:

```bash
brew install tflint
```

How to run:

```bash
tflint .
```

How to override rules:

```bash
tflint --disable-rule aws_lambda_function_tracing_rule
```

## tfsec

`tfsec` is a default static analysis tool to detect potential security risks. It's easy to integrate into a CI pipeline and has a growing library of checks against all of the major cloud providers and platforms.

Installation:

```bash
brew install tfsec
```

How to run:

```bash
tfsec .
```

How to override rules:
(you can also add an expiration date for ignoring a specific rule or limit it to a workspace)

```bash
# tfsec:ignore:aws-cloudwatch-log-group-customer-key
resource "aws_cloudwatch_log_group" "secret_rotation" {
  name = "/aws/lambda/secret_rotation"
}
```

## checkov

`checkov` is policy-as-code scanning cloud infrastructure configurations to find misconfigurations before they're deployed.

Checkov uses a common command line interface to manage and analyze infrastructure as code (IaC) scan results across platforms such as Terraform, CloudFormation, Kubernetes, Helm, ARM Templates and Serverless framework.

Installation:

```bash
brew install checkov
```

How to run:

```bash
checkov --compact -d . --quiet
```

How to override rules:

```bash
resource "aws_cloudwatch_log_group" "secret_rotation" {
  # checkov:skip=CKV_AWS_158: we do not currently require CMK for cloudwatch logging
  name = "/aws/lambda/secret_rotation"
}
```
