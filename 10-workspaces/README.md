# Workspaces

## Overview

Each Terraform configuration has an associated backend that defines how operations are executed and where persistent data such as the Terraform state are stored.

The persistent data stored in the backend belongs to a workspace. Initially the backend has only one workspace, called "default", and thus there is only one Terraform state associated with that configuration.

Certain backends support multiple named workspaces, allowing multiple states to be associated with a single configuration. The configuration still has only one backend, but multiple distinct instances of that configuration to be deployed without configuring a new backend or changing authentication credentials.

Terraform starts with a single workspace named "default". This workspace is special both because it is the default and also because it cannot ever be deleted. If you've never explicitly used workspaces, then you've only ever worked on the "default" workspace.

## Usage

Within your Terraform configuration, you may include the name of the current workspace using the ${terraform.workspace} interpolation sequence. This can be used anywhere interpolations are allowed.

Referencing the current workspace is useful for changing behavior based on the workspace. For example, for non-default workspaces, it may be useful to spin up smaller cluster sizes. For example:

```terraform
resource "aws_instance" "example" {
  count = "${terraform.workspace == "default" ? 5 : 1}"

  # ... other arguments
}
```

Another popular use case is using the workspace name as part of naming or tagging behavior:

```terraform
resource "aws_instance" "example" {
  tags = {
    Name = "web - ${terraform.workspace}"
  }

  # ... other arguments
}
```

## Workspace Commands

Workspaces are managed with the terraform workspace set of commands. To create a new workspace and switch to it, you can use `terraform workspace new;` to switch workspaces you can use `terraform workspace select;` etc.

```terraform

# create new workspace
terraform workspace new WORKSPACE_NAME

# show current workspace
terraform workspace show

# list workspaces
terraform workspace list

# switch workspace
terraform workspace select WORKSPACE_NAME

# delete workspace
terraform workspace delete WORKSPACE_NAME
```
