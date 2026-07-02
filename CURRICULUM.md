# 7-Day Terraform AWS Curriculum

This curriculum is designed for students who are starting from scratch but want to learn with professional habits from Day 1.

## Day 1: Foundations and First Terraform Workflow

**Mindset:** Terraform is a desired-state tool. You describe what infrastructure should exist, and Terraform compares that desired state with its state file and the real provider APIs.

**Topics**

- What Infrastructure as Code solves.
- Terraform vs manual AWS console work.
- HCL basics.
- Providers, resources, state, plan, apply, destroy.
- Installing Terraform and AWS CLI.
- AWS profile setup.
- Safe first project structure.

**Hands-on**

- Local warm-up lab.
- Optional AWS EC2 lab using the default VPC.

**Outcome**

Students can explain the Terraform lifecycle and run a small project safely.

## Day 2: AWS Provider, Variables, Outputs, and VPC Basics

**Mindset:** Hardcoded infrastructure becomes painful quickly. Inputs and outputs make code reusable.

**Topics**

- Provider configuration.
- Version constraints.
- Input variables and validation.
- Output values.
- Data sources.
- VPC, subnet, route table, internet gateway, and security group basics.

**Hands-on**

- Build a custom VPC.
- Launch EC2 inside a public subnet.

**Outcome**

Students can create a small but understandable AWS network and compute stack.

## Day 3: Modules and Reusable Design

**Mindset:** Copy-paste is not reuse. Modules are how Terraform code becomes a product.

**Topics**

- Root modules vs child modules.
- Module inputs and outputs.
- Naming and tagging standards.
- Module folder structure.
- When not to create a module.

**Hands-on**

- Create an EC2 module.
- Create a network module.
- Call modules from a root environment.

**Outcome**

Students can package infrastructure logic and reuse it with different inputs.

## Day 4: State, Remote Backend, and Locking

**Mindset:** State is Terraform's memory. If teams mishandle it, infrastructure becomes risky.

**Topics**

- Local state.
- Remote state.
- S3 backend.
- DynamoDB state locking.
- State drift.
- Importing existing resources.

**Hands-on**

- Create S3 backend infrastructure.
- Migrate a lab project to remote state.
- Demonstrate a plan after state migration.

**Outcome**

Students understand why production Terraform needs remote state and locking.

## Day 5: Provisioning and App Bootstrap

**Mindset:** Terraform should create infrastructure. App bootstrapping must be deliberate and limited.

**Topics**

- User data.
- `local-exec` and `remote-exec` tradeoffs.
- Why provisioners are a last resort.
- Security group rules for web traffic.
- Outputs for app URLs.

**Hands-on**

- Deploy a small web server on EC2.
- Use user data to install and start the app.
- Validate access, then destroy.

**Outcome**

Students can connect infrastructure creation with a visible application outcome.

## Day 6: Environments and Promotion

**Mindset:** Dev and prod should share logic but use different values.

**Topics**

- Environment folders.
- `.tfvars` files.
- Workspaces and when to use them.
- Naming patterns.
- Cost controls per environment.

**Hands-on**

- Create dev and prod-style configurations.
- Run plans with different variable files.

**Outcome**

Students can avoid environment drift and organize Terraform for teams.

## Day 7: Security, Review, and Production Readiness

**Mindset:** Good Terraform is not only code that works. It is code that can be reviewed, audited, upgraded, and recovered.

**Topics**

- Secrets handling.
- Least privilege IAM.
- Provider and Terraform version pinning.
- CI plan checks.
- `terraform fmt`, `validate`, and policy scanning.
- Final production checklist.

**Hands-on**

- Harden earlier labs.
- Add review checklist.
- Prepare for the AI infrastructure capstone.

**Outcome**

Students have a complete foundation for building serious AWS projects with Terraform.

## Post-Course Capstone: AI on AWS Through Terraform

After the 7-day foundation, we will build a larger AI infrastructure project. The exact design can evolve, but the target is:

- API layer for an AI application.
- Compute layer with Lambda, ECS, or both.
- Storage with S3 and DynamoDB.
- IAM policies with least privilege.
- Observability and cost controls.
- Optional Amazon Bedrock integration where available.

