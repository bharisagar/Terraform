# Lab 00: Workspace Basics

This lab teaches Terraform CLI workspaces without creating cloud resources.

## Commands

```bash
terraform fmt
terraform init
terraform validate
terraform plan
terraform workspace list
terraform workspace new dev
terraform plan
terraform workspace new prod
terraform plan
terraform workspace select default
```

Watch how outputs change based on `terraform.workspace`.

## What To Notice

- `default` always exists.
- Each workspace has its own state.
- Workspaces are useful for simple variants.
- Workspaces are not a replacement for separate credentials or accounts.
