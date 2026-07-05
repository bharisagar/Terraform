# Day 6: Environments, Workspaces, and Promotion Patterns

Welcome to Day 6.

By now you can create infrastructure, structure it with modules, store state remotely, and bootstrap apps. Day 6 teaches how teams manage dev, stage, and prod without copy-paste chaos.

## Day 6 Outcome

By the end of Day 6, you should be able to:

- Explain Terraform CLI workspaces.
- Use `terraform.workspace` safely.
- Explain why workspaces are not always the right environment strategy.
- Use `.tfvars` files for environment-specific values.
- Compare workspace, folder, and account separation patterns.
- Plan dev and prod with the same code and different inputs.
- Explain promotion from dev to prod.

## The Environment Problem

Real projects rarely have only one environment.

Typical environments:

- `dev` for fast testing.
- `stage` for pre-production verification.
- `prod` for real users.

The infrastructure logic should stay consistent, but values often differ.

| Setting | Dev | Prod |
| --- | --- | --- |
| Instance size | Small | Larger |
| High availability | Optional | Required |
| Deletion protection | Usually false | Usually true |
| Monitoring | Basic | Strong |
| Cost budget | Low | Higher |

The goal is same design, different controlled values.

## Terraform CLI Workspaces

A Terraform workspace is a named state instance for one configuration and one backend.

Terraform starts with:

```text
default
```

Useful commands:

```bash
terraform workspace list
terraform workspace new dev
terraform workspace select dev
terraform workspace show
```

Inside Terraform code, you can read the active workspace:

```hcl
terraform.workspace
```

Example:

```hcl
locals {
  environment = terraform.workspace == "default" ? "dev" : terraform.workspace
}
```

## When Workspaces Are Useful

Workspaces are useful for:

- Same credentials.
- Same backend.
- Same access boundary.
- Small differences between environments.
- Temporary review environments.
- Learning how multiple states work.

## When Workspaces Are Not Enough

Official Terraform guidance warns that CLI workspaces are not appropriate for system decomposition or deployments that need separate credentials and access controls.

Use separate folders, separate state, or separate AWS accounts when environments need real isolation.

Examples where workspaces may be a poor fit:

- Dev and prod use different AWS accounts.
- Prod has tighter IAM permissions.
- Prod needs a separate approval path.
- Different teams own different parts of the system.
- Backend access controls must differ.

## Environment Strategy Options

| Pattern | Best For | Tradeoff |
| --- | --- | --- |
| Workspaces | Small same-account variants | Easy to overuse |
| `.tfvars` files | Same code with different values | State must still be separated carefully |
| Environment folders | Clear dev/prod separation | Some folder repetition |
| Separate repos | Strong ownership separation | Harder reuse |
| Separate AWS accounts | Strong isolation | More setup and IAM work |

## Recommended Beginner Pattern

For this course:

- Use `.tfvars` files to show value differences.
- Use local workspaces to understand multiple states.
- Use separate folders or accounts for serious production boundaries later.

## Promotion Mindset

Promotion means a change proves itself in lower environments before prod.

A healthy flow:

1. Change module or root code.
2. Plan with dev values.
3. Apply to dev.
4. Test.
5. Plan with prod values.
6. Review carefully.
7. Apply to prod from a controlled place.

Never make prod the first environment that sees a new pattern.

## Day 6 Labs

### Lab 00: Workspace Basics

Path:

```text
day-06/labs/00-workspace-basics
```

This lab uses `terraform.workspace` and outputs different values per workspace without creating cloud resources.

### Lab 01: `.tfvars` Environment Pattern

Path:

```text
day-06/labs/01-tfvars-environment-pattern
```

This lab uses dev and prod variable files to show how one configuration can produce different plans.

## Professional Habits For Day 6

- Do not put secrets in `.tfvars` files that are committed.
- Commit examples, not real environment secrets.
- Keep environment differences explicit.
- Review prod plans separately from dev plans.
- Use separate AWS accounts for strong environment isolation.
- Do not use workspaces to hide major architecture differences.

## Day 6 Completion Checklist

You are done with Day 6 when you can answer these:

- What is the default Terraform workspace?
- What does `terraform.workspace` return?
- Why are workspaces not enough for separate prod credentials?
- How do `.tfvars` files help environment promotion?
- What should differ between dev and prod?
- Why should prod have separate review?
