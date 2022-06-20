# Validation

## Supported Types

* string
* number
* bool
* list(TYPE>)
* set(TYPE>)
* map(TYPE>)
* object({ATTR NAME> = TYPE, ... })

```terraform
variable "my_object" {
  type    = object({ name=string, age=number })
  default = {
    name = "John"
    age  = 52
  }
}
```

* tuple([TYPE, ...])

```terraform
variable "my_tuple" {
  type    = tuple([string, number, bool])
  default = ["a", 15, true]
}
```

## Disallowing Null Input Values

The nullable argument in a variable block controls whether the module caller may assign the value null to the variable.
The default for `nullable` is `true`.

```terraform
variable "example" {
  type     = string
  nullable = false
}
```

## Setting a domain (i.e. range of allowed values)

Specify not only the type, but also the domain of allowed variable values.

```terraform
variable "image_id" {
  type        = string
  description = "The id of the machine image (AMI) to use for the server."

  validation {
    condition     = length(var.image_id) > 4 && substr(var.image_id, 0, 4) == "ami-"
    error_message = "The image_id value must be a valid AMI id, starting with \"ami-\"."
  }
}

variable "InstanceType" {
  type        = string
  description = "AWS EC2 Instance Type"
  default     = "r4.4xlarge"

  validation {
    condition     = contains(["r4.xlarge", "r4.2xlarge", "r4.4xlarge"], var.InstanceType)
    error_message = "Unsupported Instance Type."
  }
}

variable "Region" {
  type        = string
  description = "Region to deploy into"

  validation {
    condition     = contains(["eu-west-1", "eu-west-2", "eu-central-1", "us-east-1", "us-east-2"], var.Region)
    error_message = "The Region must be one of the company's strategic AWS regions."
  }
}

variable "ProductCode" {
  type        = string
  description = "Appliance name, usually company product code (3 characters, upper case)."

  validation {
    condition     = can(regex("^[A-Za-z]+$", var.ProductCode))
    error_message = "ProductCode must only contain alphabetical characters."
  }
}
```
