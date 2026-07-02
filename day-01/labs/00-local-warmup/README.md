# Lab 00: Local Terraform Warm-Up

This lab uses Terraform without AWS. It creates a local text file so you can practice the workflow safely.

Use this lab before touching cloud resources.

## What You Will Learn

- How `terraform init` downloads a provider.
- How `terraform plan` previews a local file creation.
- How `terraform apply` creates the file.
- How `terraform destroy` removes it.
- How Terraform state remembers the file.

## Commands

Run from this folder:

```bash
terraform fmt
terraform init
terraform validate
terraform plan
terraform apply
```

After apply, Terraform creates:

```text
generated/hello-terraform.txt
```

Read the output file, then clean up:

```bash
terraform destroy
```

## What To Notice

Before apply, the file does not exist.

After apply, the file exists and Terraform state records it.

After destroy, Terraform removes the file because it is managed by Terraform.

That is the basic Terraform lifecycle in a safe local example.

