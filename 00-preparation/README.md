# Preparation

## Download "Advanced Terraform Workshop"

```bash
git clone https://github.com/mjheitland/tfworkshop.git
```

## Install Terraform

```bash
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```

Terraform is just a binary (written in Go).
If you need multiple versions or just an older version, download it from [here](https://releases.hashicorp.com/terraform/) and create a symbolic link, e.g. for macOS it is

```bash
ln -s /usr/local/Cellar/terraform/0.12.31/terraform /usr/local/bin/tf01231

You can set symbolic links to older versions:

```bash
ln -s /usr/local/Cellar/terraform/1.0.1/terraform /usr/local/bin/tf101
ln -s /usr/local/Cellar/terraform/1.2.3/terraform /usr/local/bin/terraform
```

## Add aliases

* tf=terraform
* tfa='terraform apply'
* tfd='terraform destroy'
* tff='terraform fmt'
* tfi='terraform init'
* tfm='terraform fmt -recursive'
* tfo='terraform output'
* tfp='terraform plan'
* tfv='terraform validate'

* t0='terraform init'
* t01='terraform init; terraform fmt -recursive; terraform validate'
* t1='terraform fmt -recursive; terraform validate'
* t1m='terraform fmt -recursive; terraform validate; terraform-docs markdown .'
* t2='terraform plan'
* t3='terraform apply -auto-approve'
* t3i='terraform apply'
* t4='terraform destroy -auto-approve'
* t4i='terraform destroy'

## Add .gitignore for Terraform to source folder

Check out example in this folder!

## Install Hashicorp Extensions

Hashicorp Language support can be found for almost every environment,
e.g. "Hashicorp Terraform" for Visual Studio Code
