# Bharisagar Terraform AWS: Zero to Pro

This repository is a 7-day Terraform learning path for students who want to go from absolute basics to production-minded AWS Infrastructure as Code.

The goal is not to memorize commands. The goal is to understand why each Terraform concept exists, then prove it by building small projects every day.

## Learning Promise

By the end of this course, a student should be able to:

- Explain Infrastructure as Code in simple words.
- Write readable Terraform using providers, resources, variables, outputs, data sources, and modules.
- Create AWS infrastructure safely with `terraform plan` before `terraform apply`.
- Manage state correctly instead of treating `terraform.tfstate` as a random generated file.
- Structure Terraform code like a real DevOps engineer.
- Use Git history, pull requests, and CI-style checks for infrastructure changes.
- Prepare for a larger AI-on-AWS Terraform project after the 7-day foundation.

## Course Map

| Day | Theme | Main Build |
| --- | --- | --- |
| Day 1 | Terraform foundations, installation, AWS connection, first resource | Local warm-up and first AWS EC2 lab |
| Day 2 | Providers, variables, outputs, data sources, and VPC thinking | Custom VPC with public subnet and EC2 |
| Day 3 | Reusable infrastructure with modules | Modular network and EC2 web server |
| Day 4 | State, backends, locking, and team workflow | S3 backend bootstrap and state migration practice |
| Day 5 | Provisioning, user data, and app bootstrap | Web server deployment with startup automation |
| Day 6 | Environments and workspaces | Dev and prod environment pattern |
| Day 7 | Security, policy, secrets, and production checklist | Secure Terraform workflow and final review |

After Day 7, we will build a larger AI-through-Terraform project on AWS.

## Repository Layout

```text
.
|-- README.md
|-- CURRICULUM.md
|-- day-01/
|   |-- README.md
|   `-- labs/
|-- day-02/
|   |-- README.md
|   `-- labs/
|-- day-03/
|   |-- README.md
|   `-- labs/
`-- day-04/
    |-- README.md
    `-- labs/
```

## How Students Should Use This Repo

1. Read the day notes first.
2. Run only the lab for that day.
3. Always run `terraform fmt`, `terraform validate`, and `terraform plan` before `terraform apply`.
4. Destroy paid AWS resources when the lab is complete.
5. Commit your learning changes with small messages, because infrastructure history matters.

## Progress

- Day 1: Complete
- Day 2: Complete
- Day 3: Complete
- Day 4: In progress

## Safety Rules

- Never commit AWS access keys.
- Never commit `terraform.tfstate`.
- Never run `terraform apply` without reading the plan.
- Prefer small changes over giant applies.
- Destroy temporary labs when you are done.
