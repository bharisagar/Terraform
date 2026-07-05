# Lab 01: `.tfvars` Environment Pattern

This lab shows how one Terraform configuration can produce dev and prod plans using different variable files.

No cloud resources are created.

## Commands

```bash
terraform fmt
terraform init
terraform validate
terraform plan -var-file="env/dev.tfvars"
terraform plan -var-file="env/prod.tfvars"
```

Compare the outputs.

## Lesson

The code is the same. The values are different.

This is the core idea behind environment promotion.
