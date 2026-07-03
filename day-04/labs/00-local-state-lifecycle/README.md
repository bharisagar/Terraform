# Lab 00: Local State Lifecycle

This lab teaches Terraform state using a local file resource.

It does not touch AWS.

## What You Will Learn

- Where local state is created.
- How Terraform tracks a resource address.
- How to list state resources.
- How to inspect a resource in state.
- How outputs are stored in state.
- Why state files should not be committed.

## Commands

Run from this folder:

```bash
terraform fmt
terraform init
terraform validate
terraform plan
terraform apply
```

After apply, inspect state:

```bash
terraform state list
terraform state show local_file.state_note
terraform output
```

You should also see a local file:

```text
generated/day-04-state-note.txt
```

Destroy the resource:

```bash
terraform destroy
```

## What To Notice

Before apply, Terraform only has configuration.

After apply, Terraform has:

- A real local file.
- A state file mapping `local_file.state_note` to that file.
- Outputs saved in state.

After destroy, the local file is removed and state is updated.

## Do Not Commit

The root `.gitignore` keeps state files out of Git:

```text
*.tfstate
*.tfstate.*
```

That is intentional. State can contain sensitive values.
