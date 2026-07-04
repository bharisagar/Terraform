# Topic 3: Terraform Import And Refresh

## Goal

Bring an existing manually-created EC2 instance under Terraform control without recreating it.

## Key Concept

Import connects a Terraform resource address to a real cloud object:

```text
aws_instance.imported_server -> i-0abc123456789
```

Import does not magically write perfect Terraform configuration. After import, you still need the code to match the real resource.

## Instructor Setup

Before running Terraform, create an EC2 instance manually in AWS Console:

- Name tag: `manually-created-server`
- Instance type: `t2.micro`
- AMI: Amazon Linux 2023, or set `ami_id` in Terraform to match the AMI you selected

Copy the EC2 instance ID.

## Run The Demo

```bash
terraform init
terraform plan
```

Teaching point:

Before import, Terraform says it wants to create one EC2 instance. That is not what we want because the instance already exists.

Import the real instance:

```bash
terraform import aws_instance.imported_server i-0abc123456789
```

Inspect state:

```bash
terraform state list
terraform state show aws_instance.imported_server
```

Verify configuration matches reality:

```bash
terraform plan
```

Expected best result:

```text
No changes. Your infrastructure matches the configuration.
```

If Terraform shows changes, update the code or variables to match the real EC2 instance.

## Modern Import Block Option

Terraform 1.5+ supports import blocks in configuration:

```hcl
import {
  id = "i-0abc123456789"
  to = aws_instance.imported_server
}
```

For classroom speed, the CLI command is usually easier. The import block is useful when you want import actions reviewed in code.

## Refresh

Modern `plan` and `apply` refresh state automatically. You can still run refresh explicitly:

```bash
terraform refresh
terraform plan
```

Teaching line:

Refresh reads real infrastructure and updates state. It does not change real AWS resources by itself.

## Ask Students

- Why did Terraform want to create a new EC2 before import?
- What does import add to state?
- Why can a plan still show changes after a successful import?

## Clean Up

```bash
terraform destroy -auto-approve
```

This destroys the imported instance because Terraform now manages it.
