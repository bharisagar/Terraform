# Real-Time Terraform Lab Runner

This repository now has two GitHub Actions workflows:

- `Terraform Course CI`: safe validation for all Day 1 to Day 7 labs.
- `Terraform Lab Runner`: manual runner for one selected lab, including real AWS `plan`, `apply`, and `destroy`.

Use `Terraform Lab Runner` when you want to run one specific lab, such as creating the Day 1 EC2 instance.

## Best-Practice Model

Real Terraform automation should separate these stages:

1. CI validation: format, initialize without backend, validate.
2. Plan: show what Terraform wants to create, change, or destroy.
3. Approval: human review before real AWS changes.
4. Apply: create or update infrastructure.
5. Destroy: remove training infrastructure when finished.

For this learning repository, `apply` and `destroy` are manual only.

## Required GitHub Setup

Create a GitHub environment named:

```text
terraform-labs
```

Recommended environment protection:

- Add required reviewer approval.
- Restrict deployment branches to `main`.
- Do not allow random branches to create AWS resources.

Add these environment or repository variables:

| Variable | Example | Purpose |
| --- | --- | --- |
| `AWS_ROLE_TO_ASSUME` | `arn:aws:iam::123456789012:role/github-terraform-labs` | IAM role GitHub Actions assumes through OIDC |
| `TF_STATE_BUCKET` | `bharisagar-terraform-state-123456789012` | S3 bucket where lab state is stored |

Do not use long-lived AWS access keys for this workflow.

## AWS OIDC Role Trust Policy

Create an IAM role that trusts GitHub OIDC.

Use this trust shape, replacing account/repo values only if the repository changes:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::<ACCOUNT_ID>:oidc-provider/token.actions.githubusercontent.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "token.actions.githubusercontent.com:aud": "sts.amazonaws.com",
          "token.actions.githubusercontent.com:sub": "repo:bharisagar/Terraform:environment:terraform-labs"
        }
      }
    }
  ]
}
```

For a course sandbox account, attach permissions that cover the labs you actually run. For Day 1, the role needs EC2 read/write permissions for instances, security groups, AMIs, VPC, subnets, and tags. For all seven days, the role may also need VPC, S3, IAM, and related read permissions. In production, replace broad permissions with least-privilege policies.

## Required S3 State Bucket

Before running AWS `apply`, create one S3 bucket for Terraform remote state.

Recommended bucket settings:

- versioning enabled
- server-side encryption enabled
- block public access enabled
- lifecycle policy for old noncurrent versions if needed

The workflow stores each lab under a separate key:

```text
terraform-labs/day-01/labs/01-aws-first-ec2/terraform.tfstate
```

This is why a later `destroy` can find the EC2 instance created by an earlier `apply`.

## How To Create Day 1 EC2 From GitHub

Go to:

```text
GitHub repo -> Actions -> Terraform Lab Runner -> Run workflow
```

Choose:

```text
lab: day-01/labs/01-aws-first-ec2
command: apply
aws_region: ap-south-1
confirm_resource_change: yes
```

That will:

1. assume the AWS role using GitHub OIDC
2. create a temporary S3 backend file in the runner
3. initialize Terraform with the S3 state bucket
4. validate the Day 1 lab
5. run `terraform plan`
6. run `terraform apply`

## How To Destroy Day 1 EC2

Run the same workflow again:

```text
lab: day-01/labs/01-aws-first-ec2
command: destroy
aws_region: ap-south-1
confirm_resource_change: yes
```

Always destroy training resources after practice to avoid cost.

## Same Pattern For Other Days

Use the same workflow and choose the required lab:

- Day 2 AWS VPC and EC2: `day-02/labs/01-vpc-public-web-server`
- Day 3 modular VPC and web server: `day-03/labs/01-modular-vpc-web-server`
- Day 4 S3 backend bootstrap: `day-04/labs/01-s3-backend-bootstrap`
- Day 5 EC2 user data web app: `day-05/labs/01-ec2-user-data-web-app`

Local-only labs can run `plan` from GitHub, but `apply` creates local files only inside the temporary runner. For learning local state, it is usually better to apply those labs on your laptop.

## Real-Time Rules To Follow

- Use PR validation for every change.
- Use manual `plan` before `apply`.
- Use GitHub environment approval for `apply` and `destroy`.
- Use OIDC instead of static AWS keys.
- Store state remotely in S3 with locking.
- Keep each lab in a separate state key.
- Destroy every paid resource after the lab.
