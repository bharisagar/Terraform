# Lab 03: Terraform Lifecycle Arguments

This lab teaches Terraform `lifecycle` arguments using local files.

It does not touch AWS.

## What You Will Learn

- How `create_before_destroy` changes replacement behavior.
- How `ignore_changes` can stop Terraform from updating selected arguments.
- How `replace_triggered_by` forces replacement when another managed object changes.
- How `precondition` fails early when an input is unsafe.
- Why `prevent_destroy` should be used carefully.

## Lifecycle Arguments In Simple Words

| Argument | Simple Meaning |
| --- | --- |
| `create_before_destroy` | Build the new object before removing the old one, when the provider allows it |
| `prevent_destroy` | Block plans that would delete a protected resource |
| `ignore_changes` | Tell Terraform not to repair selected changes after creation |
| `replace_triggered_by` | Replace this resource when another managed resource changes |
| `precondition` | Check a rule before Terraform acts |
| `postcondition` | Check a rule after Terraform reads or creates something |

## Commands

Run from this folder:

```bash
terraform fmt
terraform init
terraform validate
terraform plan
terraform apply
```

After apply, inspect the generated files:

```text
generated/release-v1.0.0.txt
generated/operator-note.txt
```

## Experiment 1: replace_triggered_by

Copy the example variables file:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Then change `app_version` in `terraform.tfvars`:

```hcl
app_version = "v1.1.0"
```

Run:

```bash
terraform plan
```

Terraform should plan a replacement for `local_file.release_note` because `terraform_data.app_version` changed and the file uses `replace_triggered_by`.

## Experiment 2: ignore_changes

Run another plan without changing anything:

```bash
terraform plan
```

The `operator_note` file uses `timestamp()` in its content. Normally that would create a diff on every plan. The lifecycle rule ignores content changes after the file is created:

```hcl
lifecycle {
  ignore_changes = [content]
}
```

This is useful only when another process is allowed to own that field. Do not use it to hide important drift.

## Experiment 3: prevent_destroy

Open `main.tf` and temporarily uncomment the `prevent_destroy` block inside `local_file.critical_note`.

Then run:

```bash
terraform plan -destroy
```

Terraform should reject the plan because the resource is protected.

Before cleanup, comment the block again, then run:

```bash
terraform destroy
```

## What To Notice

- Lifecycle arguments affect how Terraform builds the plan.
- `create_before_destroy` is safest when the old and new objects can exist at the same time.
- `prevent_destroy` protects critical objects but can also block cleanup.
- `ignore_changes` can reduce noisy plans, but it can hide real configuration drift.
- `replace_triggered_by` is useful when Terraform needs an explicit replacement relationship.

## Do Not Commit

Generated files and local `terraform.tfvars` are ignored by the root `.gitignore`.
