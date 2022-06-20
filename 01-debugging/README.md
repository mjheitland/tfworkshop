# Debugging Terraform

Terraform has detailed logs which can be enabled by setting the TF_LOG environment variable to any value. This will cause detailed logs to appear on stderr.

You can set TF_LOG to one of the log levels (in order of decreasing verbosity) to change the verbosity of the logs:

* TRACE
* DEBUG
* INFO
* WARN
* ERROR

Logging can be enabled separately for terraform itself and the provider plugins using the TF_LOG_CORE or TF_LOG_PROVIDER environment variables. These take the same level arguments as TF_LOG, but only activate a subset of the logs.

To persist logged output you can set TF_LOG_PATH in order to force the log to always be appended to a specific file when logging is enabled. Note that even when TF_LOG_PATH is set, TF_LOG must be set in order for any logging to be enabled.

Example macOS:

```bash
export TF_LOG=DEBUG
export TF_LOG_PATH=tfworkshop.log
# run TF commands
...
unset TF_LOG
unset TF_LOG_PATH
```

Example Windows:

```Powershell
SetEnvironmentVariable("TF_LOG", "DEBUG" ,"User")
SetEnvironmentVariable("TF_LOG_PATH", "tfworkshop.log" ,"User")
# run TF commands
...
SetEnvironmentVariable("TF_LOG", $null ,"User")
SetEnvironmentVariable("TF_LOG_PATH", $null ,"User")
```

## Terraform Console

This command provides an interactive command-line console for evaluating and experimenting with expressions. You can use it to test interpolations before using them in configurations and to interact with any values currently saved in state. If the current state is empty or has not yet been created, you can use the console to experiment with the expression syntax and built-in functions. The console holds a lock on the state, and you will not be able to use the console while performing other actions that modify state.

Testing functions:

```bash
echo 'split(",", "foo,bar,baz")' | terraform console
```

Checking Terraform variables:

```bash
echo 'terraform.workspace' | terraform console

echo 'cidrnetmask("172.16.0.0/12")' | terraform console
```

Test local state:

```bash
terraform console
> var.apps.foo
> { for key, value in var.apps : key => value if value.region == "us-east-1" }
> random_pet.example
```
