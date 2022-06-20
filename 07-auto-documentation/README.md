# terraform-docs

**terraform-docs** is a tool to auto-generate consistent documentation for Terraform modules.

Installation on macOS:

```bash
brew install terraform-docs
```

The `terraform-docs` tool is used to generate the majority of technical documentation for each module, which includes:

- requirements
- providers
- modules
- resources
- inputs
- outputs

Descriptions should be added to every input (variable) and output within the terraform itself.
These descriptions should be written using complete sentences and should include enough detail
for consumers to understand what the input or output does.

For long descriptions, use a heredoc and ensure that newlines are included to keep the length of the lines
within the 120 character limit.

Command:

```bash
terraform-docs markdown . >> README.md
```

## Links

- [terraform-docs homepage](https://github.com/terraform-docs/terraform-docs)
- [user guide](https://terraform-docs.io/user-guide/introduction/)
