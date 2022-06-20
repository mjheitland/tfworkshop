# Style

The Terraform parser allows you some flexibility in how you lay out the elements in your configuration files, but the Terraform language also has some idiomatic style conventions which we recommend users always follow for consistency between files and modules written by different teams. Automatic source code formatting tools may apply these conventions automatically.

To enforce style conventions, run

```terraform
terraform fmt -recursive
```

## Conventions

* Indent two spaces for each nesting level.
* When both arguments and blocks appear together inside a block body, place all of the arguments together at the top and then place nested blocks below them. Use one blank line to separate the arguments from the blocks.
* Use empty lines to separate logical groups of arguments within a block.
* Top-level blocks should always be separated from one another by one blank line. Nested blocks should also be separated by blank lines, except when grouping together related blocks of the same type (like multiple provisioner blocks in a resource).
* Avoid separating multiple blocks of the same type with other blocks of a different type, unless the block types are defined by semantics to form a family. (For example: root_block_device, ebs_block_device and ephemeral_block_device on aws_instance form a family of block types describing AWS block devices, and can therefore be grouped together and mixed.)
* Use snake_case for naming all resources, input variables, output variables and module names
* Do not reuse the resource type within the resource name (resource "aws_subnet" "private" instead of "private_subnet")
* Always provide type and description for your variables, set defaults where it makes sense
* Prefer local variable maps keyed to your workspace instead of different .tfvars files
* Tag all your resources consistently using default_tags (combined with a tagging module might help here)

```terraform
provider "aws" {
  default_tags {
    tags = {
      author           = "Michael Heitland"
      "ops/managed-by" = "terraform"
    }
  }
}
```

* You can use `heredoc` strings, e.g. for a policy ("<<-" removes trailing tabs, it makes your code easier to read)

```terraform
policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
    ...
    ]
  }
EOF
```

* When multiple arguments with single-line values appear on consecutive lines at the same nesting level, align their equals signs:

```terraform
ami           = "abc123"
instance_type = "t2.micro"
```

* For blocks that contain both arguments and "meta-arguments" (as defined by the Terraform language semantics), list meta-arguments first and separate them from other arguments with one blank line. Place meta-argument blocks last and separate them from other blocks with one blank line.

```terraform
resource "aws_instance" "example" {
  count = 2 # meta-argument first

  ami           = "abc123"
  instance_type = "t2.micro"

  network_interface {
    # ...
  }

  lifecycle { # meta-argument block last
    create_before_destroy = true
  }
}
```

## Helpful Resources

* [Style Guide](https://www.terraform.io/language/syntax/style)
* [How to create modules](https://www.terraform.io/docs/language/modules/develop/index.html)
* [Module Structure](https://www.terraform.io/language/modules/develop/structure)
