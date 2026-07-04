# Topic 2: Terraform Drift

## Goal

Show that Terraform detects when real AWS infrastructure has changed outside the code.

Drift means reality no longer matches Terraform's desired configuration.

## Key Concept

`terraform plan` compares:

```text
Terraform code + Terraform state + Real AWS resources
```

If someone manually changes AWS resources, `terraform plan` shows what Terraform would do to bring reality back to the code.

## Run The Demo

```bash
terraform init
terraform apply -auto-approve
terraform output instance_id
terraform output security_group_id
```

## Demo A: EC2 Instance Type Drift

In AWS Console:

1. Go to EC2 -> Instances.
2. Find `drift-demo-server`.
3. Stop the instance.
4. Change the instance type from `t2.micro` to `t2.small`.
5. Start the instance again.

Then run:

```bash
terraform plan
```

Expected plan idea:

```text
~ instance_type = "t2.small" -> "t2.micro"
```

The `~` means Terraform plans to update the resource.

## Demo B: Security Group Rule Drift

In AWS Console:

1. Go to EC2 -> Security Groups.
2. Find the security group tagged `drift-demo-sg`.
3. Delete the inbound SSH rule for port `22`.
4. Save the rule change.

Then run:

```bash
terraform plan
```

Expected plan idea:

```text
+ ingress { from_port = 22 ... }
```

Terraform sees that a rule in the code is missing from AWS and plans to add it back.

## Fix The Drift

```bash
terraform apply -auto-approve
```

Teaching line:

Terraform code is the source of truth. Manual console changes might feel quick, but they create invisible risk until `terraform plan` catches them.

## Ask Students

- How would you know about this change without Terraform?
- Should teams allow manual console edits in production?
- Where should `terraform plan` run in a real delivery process?

## Clean Up

```bash
terraform destroy -auto-approve
```
