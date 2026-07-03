# Lab 00: Local Module Basics

This lab teaches Terraform modules without creating AWS resources.

You will call a local child module named `naming-standard` from a root module.

## What You Will Learn

- What a root module is.
- What a child module is.
- How `source = "./modules/name"` works.
- How to pass inputs into a module.
- How to read module outputs.
- How a module can standardize names and tags.

## Folder Structure

```text
00-local-module-basics/
|-- main.tf
|-- variables.tf
|-- outputs.tf
|-- terraform.tfvars.example
`-- modules/
    `-- naming-standard/
        |-- README.md
        |-- variables.tf
        |-- locals.tf
        `-- outputs.tf
```

## Commands

Run from this folder:

```bash
terraform fmt -recursive
terraform init
terraform validate
terraform plan
```

This lab creates no cloud resources. The plan only shows output values.

You can apply if you want to save outputs in local state:

```bash
terraform apply
terraform destroy
```

## Try Custom Values

Copy the example file:

```powershell
Copy-Item terraform.tfvars.example terraform.tfvars
```

Or on macOS/Linux:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Then run:

```bash
terraform plan -var-file="terraform.tfvars"
```

## Practice Questions

- Which folder is the root module?
- Which folder is the child module?
- Which values are passed as inputs?
- Which values come back as outputs?
- How would this naming module help multiple AWS projects stay consistent?
