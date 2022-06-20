# Layout

It is helpful to standardize the layout of your Terraform configuration files.
A consistent layout makes it easy for everyone to navigate your code.

"terraform-aws-vpc" is a good example for a layout of modules and of application code.

## Minimal Project

```bash
$ tree my-simple-project
.
|- README.md
|- main.tf
|- variables.tf (alternative: _variables.tf)
|- outputs.tf (alternative: _outputs.tf
|- versions.tf (alternative: _versions.tf or providers.tf)
```

## Layered Project

```bash
$ tree my-layered-project
.
|- README.md
|- 00_tfstate\
   |- ...
|- 10_network\
   |- ...
|- 20_security\
   |- ...
|- 30_storage\
   |- ...
|- 40_compute\
   |- ...
|- 50_database\
   |- ...
|- 60_apps\
   |- ...
```

## Module

```bash
$ tree my-module
.
|- .gitignore
|- CHANGELOG.md
|- LICENSE
|- README.md
|- main.tf
|- helper-code-1.tf
|- ...
|- variables.tf
|- outputs.tf
|- versions.tf
|- modules/
   |- nestedA/
      |- README.md
      |- main.tf
      |- variables.tf
      |- outputs.tf
      |- versions.tf
   |- nestedB/
      |- README.md
      |- ...
|- examples/
   |- exampleA/
      |- README.md
      |- main.tf
      |- variables.tf
      |- outputs.tf
      |- versions.tf
   |- exampleB/
      |- README.md
      |- ...
```
