# Day 7: Security, Policy, Secrets, and Production Readiness

Welcome to Day 7.

The first six days taught how to write Terraform and build AWS patterns. Day 7 teaches how to make Terraform safer for real teams.

Working Terraform is not enough. Production Terraform must be reviewable, auditable, recoverable, and secure.

## Day 7 Outcome

By the end of Day 7, you should be able to:

- Explain why secrets and state need special care.
- Use `sensitive = true` correctly without over-trusting it.
- Explain why sensitive values can still end up in state.
- Describe least privilege IAM for Terraform.
- Explain provider and Terraform version pinning.
- Describe CI checks for Terraform pull requests.
- Use Terraform `check` blocks for readiness checks.
- Review a project before production use.
- Prepare for the AI-on-AWS capstone project.

## Terraform Security Mindset

Terraform can create powerful infrastructure quickly.

That means mistakes can also happen quickly.

Security-minded Terraform asks:

- Who can run `apply`?
- Where is state stored?
- Who can read state?
- Are secrets stored in code, variables, or state?
- Are providers pinned?
- Are plans reviewed?
- Are destructive changes visible before apply?
- Are IAM permissions least privilege?
- Can we recover from a bad change?

## Sensitive Values

Terraform supports sensitive input variables and outputs.

Example:

```hcl
variable "db_password" {
  type      = string
  sensitive = true
}
```

Sensitive values are hidden from normal CLI output.

Important warning:

`sensitive = true` hides display. It does not automatically remove the value from state.

If a provider stores a secret in resource attributes, that secret may still exist in `terraform.tfstate`.

That is why remote state must be encrypted, access-controlled, and treated like sensitive data.

## Secrets Handling Options

Prefer these patterns:

| Pattern | Use Case |
| --- | --- |
| AWS Secrets Manager | Application secrets on AWS |
| AWS SSM Parameter Store | Config values and some secrets |
| HashiCorp Vault | Centralized secret workflows |
| CI/CD secret store | Pipeline-only inputs |
| IAM roles/OIDC | Avoid long-lived access keys |
| Ephemeral/write-only arguments | When supported by Terraform/provider versions |

Avoid:

- Committing `.tfvars` files with real secrets.
- Putting secrets in `user_data` if they can be read later.
- Storing private keys in the repo.
- Printing secrets in outputs.

## IAM For Terraform

Terraform should not always run as administrator.

A production approach uses:

- Dedicated IAM role for Terraform.
- Least privilege policies.
- Separate roles for dev and prod.
- Strong approval before assuming prod role.
- Short-lived credentials.
- CloudTrail audit.

For GitHub Actions, prefer OIDC federation instead of stored AWS access keys.

## State Security

State security checklist:

- Remote backend enabled.
- S3 bucket versioning enabled.
- S3 encryption enabled.
- Public access blocked.
- Locking enabled.
- Access restricted to the Terraform role and trusted admins.
- State bucket changes reviewed.
- State files never committed.

## Version Pinning

Pin Terraform and provider versions.

Example:

```hcl
terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
```

Commit `.terraform.lock.hcl` for real projects so provider selections are repeatable.

## CI Checks

A strong pull request pipeline runs:

```bash
terraform fmt -check -recursive
terraform init -backend=false
terraform validate
terraform plan
```

Teams may also add:

- Checkov.
- tfsec or Trivy config scanning.
- Infracost.
- OPA or Sentinel policy checks.
- Drift detection plan schedules.

## Terraform `check` Blocks

`check` blocks let Terraform evaluate assertions and report warnings during plan/apply.

They are useful for non-blocking readiness checks.

Example:

```hcl
check "remote_state_enabled" {
  assert {
    condition     = var.remote_state_enabled
    error_message = "Remote state should be enabled before production."
  }
}
```

Use them to teach standards and catch risky defaults.

## Final Production Review

Before production apply, review:

- Blast radius.
- Plan output.
- State backend.
- IAM role.
- Secrets handling.
- Network exposure.
- Tags and cost controls.
- Logging and monitoring.
- Rollback plan.
- Destroy protection.

## Day 7 Labs

### Lab 00: Sensitive Values Demo

Path:

```text
day-07/labs/00-sensitive-values-demo
```

This lab demonstrates sensitive variables and outputs without cloud resources.

### Lab 01: Production Readiness Checks

Path:

```text
day-07/labs/01-production-readiness-checks
```

This lab models a production checklist using Terraform variables, outputs, and `check` blocks.

## Capstone Readiness

After Day 7, students are ready for the AI-through-Terraform project because they now know:

- AWS provider basics.
- VPC and EC2 infrastructure.
- Modules.
- Remote state.
- Environment strategy.
- Bootstrap patterns.
- Security review.

## Day 7 Completion Checklist

You are done with Day 7 when you can answer these:

- Does `sensitive = true` remove values from state?
- Why is remote state security important?
- Why should Terraform use least privilege IAM?
- What CI checks should run before merge?
- What does provider version pinning prevent?
- What should be reviewed before production apply?
- What is the next big project after this course?
