# Lab 00: Local Exec Provisioner

This lab demonstrates a Terraform provisioner safely on your local machine.

It uses the built-in `terraform_data` resource and a `local-exec` provisioner.

## What You Will Learn

- How `local-exec` runs on the machine running Terraform.
- Why provisioners run during resource creation by default.
- How provisioner environment variables work.
- Why provisioner output is outside Terraform's normal resource model.
- How `triggers_replace` can cause a provisioner to run again.

## Commands

Run from this folder:

```bash
terraform fmt
terraform init
terraform validate
terraform plan
terraform apply
```

On Windows, the default command writes:

```text
generated/local-exec-demo.txt
```

Destroy when finished:

```bash
terraform destroy
```

## macOS/Linux Override

The defaults are Windows-friendly. On macOS/Linux, copy the example file and edit the command:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Use values like:

```hcl
local_exec_interpreter = ["/bin/sh", "-c"]
local_exec_command     = "mkdir -p generated && printf '%s\n' \"$DEMO_MESSAGE\" > generated/local-exec-demo.txt"
```

Then run:

```bash
terraform apply -var-file="terraform.tfvars"
```

## Important Lesson

Terraform can track `terraform_data.local_exec_demo`, but it does not deeply understand the side effects of your shell command.

That is why provisioners should stay small and deliberate.
