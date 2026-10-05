# GitHub Actions Best Practice for This Terraform Course

This repository has many small Terraform labs from Day 1 to Day 7. The best practice is to use GitHub Actions as a quality gate first, not as an automatic AWS deployment engine.

There are two workflows:

- `Terraform Course CI`: automatic safety check for all course labs.
- `Terraform Lab Runner`: manual workflow for one selected lab, including real `plan`, `apply`, and `destroy`.

## What Runs Automatically

The workflow in `.github/workflows/terraform-course-ci.yml` runs on:

- pull requests that change `day-*` folders
- pushes to `main` that change `day-*` folders
- manual `workflow_dispatch`

It performs:

- `terraform fmt -check -diff -recursive` for Day 1 to Day 7
- `terraform init -backend=false` for every root lab folder
- `terraform validate` for every root lab folder

This is safe for a learning repository because it checks code quality without creating AWS resources.

## Why We Do Not Auto-Apply Every Lab

Do not run `terraform apply` automatically for Day 1 to Day 7.

Reasons:

- Several labs create paid AWS resources such as EC2, VPC, S3, IAM, and Elastic IP resources.
- Some labs intentionally teach state, backend migration, drift, import, and lifecycle behavior.
- Automatic apply can leave real infrastructure running if a later step fails.
- Students should learn to review a Terraform plan before any apply.

## Recommended Professional Flow

Use this flow for this course:

1. Student opens a pull request.
2. GitHub Actions runs `fmt`, `init`, and `validate`.
3. Reviewer checks the code and lab explanation.
4. Student runs `terraform plan` locally or in a protected manual workflow.
5. Student applies only the selected lab.
6. Student destroys lab infrastructure after practice.

## Future Production Flow

For the later AI capstone project, use a stronger workflow:

- `pull_request`: run `fmt`, `init`, `validate`, security scan, and `terraform plan`
- `push` to `main`: run plan again
- protected environment approval: run `terraform apply`
- AWS authentication: use GitHub OIDC, not long-lived AWS access keys
- state: use a remote backend with locking
- secrets: store secrets in GitHub Environments, AWS Secrets Manager, or HCP Terraform
- branch protection: require the Terraform workflow before merge

## Manual Lab Runner

Use `Terraform Lab Runner` only when you intentionally want to run one lab in real AWS.

Example for Day 1 EC2:

- `lab`: `day-01/labs/01-aws-first-ec2`
- `command`: `apply`
- `aws_region`: `ap-south-1`
- `confirm_resource_change`: `yes`

Run `command: destroy` with the same lab after practice.

Read `REAL-TIME-LAB-RUNNER.md` before using this workflow because it requires GitHub OIDC and an S3 state bucket.

## Security Rules

- Never commit `.tfstate`, `.tfvars`, plan files, or AWS credentials.
- Prefer GitHub OIDC for AWS access.
- Keep `permissions: contents: read` for validation-only jobs.
- Use protected environments before any real `apply`.
- Keep `terraform apply` manual for training labs.

## Root Lab Folders Validated

The workflow validates these Day 1 to Day 7 root modules:

- `day-01/labs/00-local-warmup`
- `day-01/labs/01-aws-first-ec2`
- `day-02/labs/00-variables-locals-outputs`
- `day-02/labs/01-vpc-public-web-server`
- `day-03/labs/00-local-module-basics`
- `day-03/labs/01-modular-vpc-web-server`
- `day-04/labs/00-local-state-lifecycle`
- `day-04/labs/01-s3-backend-bootstrap`
- `day-04/labs/02-s3-backend-migration-practice`
- `day-04/labs/03-lifecycle-arguments`
- `day-05/labs/00-local-exec-provisioner`
- `day-05/labs/01-ec2-user-data-web-app`
- `day-06/labs/00-workspace-basics`
- `day-06/labs/01-tfvars-environment-pattern`
- `day-07/labs/00-sensitive-values-demo`
- `day-07/labs/01-production-readiness-checks`
