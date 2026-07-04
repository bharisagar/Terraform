# Topic 1: Terraform Workspaces

## Goal

Use the same Terraform code to deploy separate `dev`, `prod`, and optional `staging` environments.

Students should see that the active workspace changes:

- The EC2 instance name.
- The EC2 instance type.
- The S3 bucket name.
- The local state file Terraform uses.

## Key Concept

`terraform.workspace` is a built-in value. It always contains the currently selected workspace name.

This module uses it in two important places:

```hcl
instance_type = lookup(local.instance_type_map, terraform.workspace, "t3.micro")
Name          = "${terraform.workspace}-app-server"
```

That means one codebase can behave differently per environment without copying folders.

## Run The Demo

```bash
terraform init
terraform workspace show
terraform workspace list
```

You should start in the `default` workspace.

### Deploy dev

```bash
terraform workspace new dev
terraform workspace show
terraform apply -auto-approve
terraform output
```

Point out:

- `current_workspace = "dev"`
- `instance_type_used = "t3.micro"`
- Resource names include `dev`.

### Deploy prod

```bash
terraform workspace new prod
terraform apply -auto-approve
terraform output
```

Point out:

- `current_workspace = "prod"`
- `instance_type_used = "t3.small"`
- Resource names include `prod`.

## Show Separate State

```bash
ls terraform.tfstate.d/
ls terraform.tfstate.d/dev/
ls terraform.tfstate.d/prod/
```

Teaching line:

`dev` and `prod` are not just different names. They have separate state files. Terraform knows which resources belong to each workspace because it reads the state for the selected workspace only.

## Switch Between Environments

```bash
terraform workspace select dev
terraform show

terraform workspace select prod
terraform show
```

Ask students:

- Why does `prod` get a bigger instance type?
- What would happen if `dev` and `prod` shared the same state file?
- Why can you not delete the `default` workspace?

## Student Mini-Challenge

```bash
terraform workspace new staging
terraform apply -auto-approve
terraform output instance_type_used
terraform output s3_bucket_name
```

Expected result: `staging` uses `t3.micro` unless you change `local.instance_type_map`.

## Clean Up

Destroy each workspace before leaving the topic:

```bash
terraform workspace select dev
terraform destroy -auto-approve

terraform workspace select prod
terraform destroy -auto-approve

terraform workspace select staging
terraform destroy -auto-approve

terraform workspace select default
```
