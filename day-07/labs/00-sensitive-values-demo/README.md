# Lab 00: Sensitive Values Demo

This lab demonstrates Terraform sensitive variables and outputs without creating cloud resources.

## Commands

```bash
terraform fmt
terraform init
terraform validate
terraform plan -var-file="terraform.tfvars.example"
```

## What To Notice

- Sensitive output values are hidden in the plan.
- Sensitivity is a display control, not a full secret-management system.
- State must still be protected.

## Important

The example password is fake. Never commit real secrets.
