# Lab 01: S3 Backend Bootstrap

This lab creates an S3 bucket suitable for Terraform remote state.

Use local state for this bootstrap step. After the bucket exists, other projects can use it as their remote backend.

## What Terraform Creates

- S3 bucket with a generated unique suffix.
- S3 bucket versioning.
- S3 server-side encryption.
- S3 public access block.
- Bucket policy denying insecure HTTP transport.

## Modern Locking Note

For new S3 backend projects, use:

```hcl
use_lockfile = true
```

DynamoDB locking appears in many older tutorials, but it is now deprecated for the Terraform S3 backend.

## Cost Warning

S3 is low cost, but not free forever. Destroy lab resources when you no longer need them.

If the bucket contains state files, do not destroy it until those states are migrated or intentionally deleted.

## Setup

Copy the example values:

```powershell
Copy-Item terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` if needed.

Verify AWS identity:

```bash
aws sts get-caller-identity --profile terraform-day4
```

## Commands

```bash
terraform fmt
terraform init
terraform validate
terraform plan -var-file="terraform.tfvars"
terraform apply -var-file="terraform.tfvars"
```

## Use The Output

After apply, copy the `backend_hcl` output into another project as `backend.tf`, then run:

```bash
terraform init -migrate-state
```

## Cleanup

Only destroy the backend bucket if it does not contain important state:

```bash
terraform destroy -var-file="terraform.tfvars"
```
