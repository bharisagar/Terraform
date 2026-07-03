# Lab 02: S3 Backend Migration Practice

This lab practices the workflow for moving a small Terraform project from local state to S3 remote state.

The backend file is intentionally named `backend.tf.example` so validation works before students have a real bucket name.

## What You Will Learn

- How a project starts with local state.
- How backend configuration is added.
- How `terraform init -migrate-state` migrates state.
- How S3 lock files are enabled with `use_lockfile = true`.

## Step 1: Run With Local State

```bash
terraform fmt
terraform init
terraform validate
terraform apply
terraform state list
```

This creates a local file and local `terraform.tfstate`.

## Step 2: Add Backend Configuration

Copy the example:

```powershell
Copy-Item backend.tf.example backend.tf
```

Edit `backend.tf` and replace:

- `REPLACE_WITH_BUCKET_FROM_LAB_01`
- `ap-south-1` if your bucket is in another region
- `terraform-day4` if your profile has another name

## Step 3: Migrate State

Run:

```bash
terraform init -migrate-state
```

Terraform asks whether to copy existing local state to S3. Read the prompt and approve only if the bucket is correct.

## Step 4: Inspect

```bash
terraform state list
terraform output
```

The state should now live in S3.

## Step 5: Cleanup

Destroy the managed local file:

```bash
terraform destroy
```

If you used the S3 backend, this updates remote state.

## Important

Do not commit `backend.tf` after filling real backend details unless your team has agreed that backend configuration belongs in the repo.

Never commit `terraform.tfstate`.
