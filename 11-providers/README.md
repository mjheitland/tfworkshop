# Providers

## Overview

Terraform relies on plugins called "providers" to interact with cloud providers, SaaS providers, and other APIs.

Terraform configurations must declare which providers they require so that Terraform can install and use them. Additionally, some providers require configuration (like endpoint URLs or cloud regions) before they can be used.

Each provider adds a set of resource types and/or data sources that Terraform can manage.

Every resource type is implemented by a provider; without providers, Terraform can't manage any kind of infrastructure.

Most providers configure a specific infrastructure platform (either cloud or self-hosted). Providers can also offer local utilities for tasks like generating random numbers for unique resource names.

Providers are distributed separately from Terraform itself, and each provider has its own release cadence and version numbers.

The [Terraform Registry](https://registry.terraform.io/browse/providers) is the main directory of publicly available Terraform providers, and hosts providers for most major infrastructure platforms.

## Semantic versioning and version constraints

Semantic versioning uses version tags in the form x.y.z (x = major version, y = minor version, z = patch).
Major versions can add incompatible changes, minor versions add functionality with backward compatibility and patches make backwards compatible bug fixes.

Variations:

```terraform
version = ">= 1.2, < 1.3"
is the same as
version = "~> 1.2
```

Example: accept any provider with major version 4 (4.0 <= version < 5.0)

```terraform
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
```

## Default tags

Default tags are tags that will be added to all resources that this provider deploys.
So we won't see any resources without basic tagging.
This can also help to track usage of modules.

```terraform
provider "aws" {
  region = "eu-west-1"
  default_tags {
    tags = {
      example          = "aws/storage"
      "ops/managed-by" = "terraform"
    }
  }
}
```

## Aliases

Alias: for using the same provider with different configurations for different resources.

You can optionally define multiple configurations for the same provider, and select which one to use on a per-resource or per-module basis. The primary reason for this is to support multiple regions for a cloud platform; other examples include targeting multiple Docker hosts, multiple Consul hosts, etc.

```terraform
# The default provider configuration; resources that begin with `aws_` will use
# it as the default, and it can be referenced as `aws`.
provider "aws" {
  region = "us-east-1"
}

# Additional provider configuration for west coast region; resources can
# reference this as `aws.west`.
provider "aws" {
  alias  = "us"
  region = "us-west-2"
}
```

Use the provider in a resource, data source or in a module

```terraform
# Log into a different region
resource "aws_cloudwatch_log_group" "primary" {
  provider = aws.us
  ...
}

# Get data source from a different region
data "aws_route53_zone" "dns" {
  provider = aws.us
  name     = var.dns-name
}

# An example child module is instantiated with the alternate configuration,
# so any AWS resources it defines will use the us-west-2 region.
module "example" {
  source    = "./example"
  providers = {
    aws = aws.us
  }
}
```
