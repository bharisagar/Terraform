# Topic 4: Force Replacement With -replace

## Goal

Force Terraform to rebuild one resource even when the code has not changed.

## Key Concept

Use `terraform apply -replace=ADDRESS` when the code is correct but the resource is unhealthy or should be rebuilt from scratch.

Example address:

```text
aws_instance.app_server
```

## Run The Demo

```bash
terraform init
terraform apply -auto-approve
terraform output instance_id
terraform output elastic_ip
```

Write down the first `instance_id`.

Force replacement:

```bash
terraform apply -replace=aws_instance.app_server
```

Terraform shows `-/+`, meaning destroy and create replacement.

After apply:

```bash
terraform output instance_id
terraform output elastic_ip
```

Expected result:

- `instance_id` changed because the EC2 instance is brand new.
- `elastic_ip` stayed the same because the Elastic IP is a separate AWS resource reattached to the replacement EC2 instance.

## Old Taint Commands

Students may see these in old projects:

```bash
terraform taint aws_instance.app_server
terraform untaint aws_instance.app_server
```

Explain them for recognition, but teach `-replace` as the preferred modern command.

## When To Use -replace

Good examples:

- A server is corrupted.
- A bootstrap script failed and you want a clean rerun.
- A node should be rotated without changing permanent code.
- A resource should be recreated exactly as described in code.

Do not use `-replace` for permanent configuration changes. Change the Terraform code instead.

## Ask Students

- What does `-/+` mean in a Terraform plan?
- Why did the EC2 ID change?
- Why did the Elastic IP stay the same?

## Clean Up

```bash
terraform destroy -auto-approve
```
