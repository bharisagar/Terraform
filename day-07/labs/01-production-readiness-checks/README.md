# Lab 01: Production Readiness Checks

This lab models production readiness using Terraform variables, outputs, and `check` blocks.

No cloud resources are created.

## Commands

```bash
terraform fmt
terraform init
terraform validate
terraform plan -var-file="production-ready.tfvars"
```

Try changing a value to `false` and run plan again to see check warnings.

## Lesson

A checklist is stronger when it is close to the code and repeated in CI.
