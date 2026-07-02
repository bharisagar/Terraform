# Lab 00: Variables, Locals, and Outputs

This lab teaches Terraform inputs and outputs without creating AWS resources.

Use it to practice the language before you touch cloud infrastructure.

## What You Will Learn

- How to define input variables.
- How to validate variable values.
- How to use lists and maps.
- How to calculate naming patterns with locals.
- How to merge common tags.
- How to expose useful values through outputs.

## Commands

Run from this folder:

```bash
terraform fmt
terraform init
terraform validate
terraform plan
terraform apply
```

This lab does not create cloud resources. `terraform apply` only stores outputs in local Terraform state.

To clean the local state:

```bash
terraform destroy
```

## Try Custom Values

Copy the example file:

Windows PowerShell:

```powershell
Copy-Item terraform.tfvars.example terraform.tfvars
```

macOS/Linux:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Then edit values and run:

```bash
terraform plan -var-file="terraform.tfvars"
```

## Practice Questions

After running the lab, answer:

- Which values came from variables?
- Which values were calculated in locals?
- What changed when you edited `terraform.tfvars`?
- Why is `common_tags` easier than writing tags on every resource?
