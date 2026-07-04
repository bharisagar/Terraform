# Topic 6: Remote State And Locking

## Goal

Move Terraform state from the local machine to S3 and enable state locking so two users cannot safely write the same state at the same time.

## Key Concept

State is Terraform's memory. In a team, local state is dangerous because every person has a different copy. Remote state gives the team one shared source of truth.

This module uses:

- S3 bucket for remote state storage.
- S3 bucket versioning for state recovery.
- S3 public access block and encryption for safer state storage.
- S3 lock file via `use_lockfile = true` for state locking.

Legacy note: older examples often use DynamoDB for S3 backend locking. Current Terraform documentation marks DynamoDB-based S3 locking as deprecated. This lab uses the modern S3 lock file approach.

## Step 1: Create The Backend Bucket

```bash
chmod +x setup-backend.sh
./setup-backend.sh
cat .bucket-name
```

The script creates an S3 bucket, enables versioning, blocks public access, enables encryption, and saves the bucket name in `.bucket-name`.

## Step 2: Update backend.tf

Open `backend.tf` and replace:

```hcl
bucket = "terraform-state-demo-YOUR-BUCKET-NAME"
```

with the bucket name printed by the script.

The important backend settings are:

```hcl
key                  = "terraform.tfstate"
workspace_key_prefix = "env"
use_lockfile         = true
```

For workspace `dev`, Terraform stores state at:

```text
env/dev/terraform.tfstate
```

During an active operation, the lock file path is:

```text
env/dev/terraform.tfstate.tflock
```

## Step 3: Initialize Remote Backend

```bash
terraform init
```

If Terraform asks whether to copy existing state to S3, answer `yes`.

## Step 4: Deploy In dev Workspace

```bash
terraform workspace new dev
terraform apply -auto-approve
terraform output
```

Show students the state path:

```bash
terraform output workspace_state_key
terraform output workspace_lock_key
```

View the state object in S3:

```bash
aws s3 ls "s3://$(cat .bucket-name)" --recursive
aws s3 cp "s3://$(cat .bucket-name)/env/dev/terraform.tfstate" - | python3 -m json.tool | head -60
```

Point out resource IDs, IP addresses, and IAM role ARNs. Explain that state can contain sensitive data and must be protected.

## Step 5: Lock Demo

Open two terminal windows in this folder.

Terminal 1:

```bash
terraform apply -auto-approve
```

Terminal 2, while Terminal 1 is still running:

```bash
terraform apply
```

Expected behavior: Terminal 2 should wait or fail with a lock message because another Terraform operation owns the lock.

Teaching line:

The lock prevents state corruption. Without it, two users could overwrite each other's state writes.

## Step 6: State Commands

```bash
terraform state list
terraform state show aws_instance.state_demo
terraform state show aws_iam_role.app_role
```

Remove one object from state without deleting it in AWS:

```bash
terraform state rm aws_s3_bucket.app_data
terraform state list
terraform plan
```

Terraform now wants to create the bucket again because it forgot the existing bucket.

Import it back:

```bash
terraform import aws_s3_bucket.app_data "$(terraform output -raw s3_bucket)"
terraform state list
```

## Step 7: Optional prod Workspace

```bash
terraform workspace new prod
terraform apply -auto-approve
aws s3 ls "s3://$(cat .bucket-name)" --recursive
```

You should see separate workspace state paths.

## Ask Students

- Why is local state risky for a team?
- Why should S3 state buckets have versioning enabled?
- What does the lock file prevent?
- Why should secrets not be hardcoded in Terraform variables?

## Clean Up Everything

Destroy Terraform-managed resources:

```bash
terraform workspace select dev
terraform destroy -auto-approve

terraform workspace select prod
terraform destroy -auto-approve
```

Delete backend infrastructure:

```bash
aws s3 rm "s3://$(cat .bucket-name)" --recursive
aws s3api delete-bucket --bucket "$(cat .bucket-name)"
```
