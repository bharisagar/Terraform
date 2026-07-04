# Topic 5: Provisioners And null_resource

## Goal

Demonstrate the three Terraform provisioner types and show how `null_resource` can run commands without representing real infrastructure.

## Key Concept

Provisioners run after resource creation or before resource destruction.

This module demonstrates:

- `local-exec`: runs on your machine.
- `file`: copies `deploy.sh` from your machine to EC2.
- `remote-exec`: runs commands on EC2 over SSH.
- `null_resource`: runs a provisioner after the EC2 instance is ready.

Production warning: provisioners are a last resort. Prefer cloud-init/user data, immutable images, configuration management, or CI/CD deployment tools for production systems.

## Prerequisite

Create a key pair in AWS before running this module:

```bash
# AWS Console -> EC2 -> Key Pairs -> Create key pair
# Name: demo-keypair
# Format: .pem

mkdir -p ~/.ssh
mv ~/Downloads/demo-keypair.pem ~/.ssh/
chmod 400 ~/.ssh/demo-keypair.pem
```

If you use a different key name or path, pass variables:

```bash
terraform apply \
  -var='key_name=my-key' \
  -var='private_key_path=~/.ssh/my-key.pem'
```

For a safer SSH rule, restrict `allowed_ssh_cidr` to your public IP.

## Review Before Apply

```bash
cat main.tf
cat deploy.sh
```

Point out:

- The `connection` block tells Terraform how to SSH to EC2.
- `local-exec` writes `created_servers.log` on the machine running Terraform.
- `file` copies `deploy.sh` to `/home/ec2-user/deploy.sh`.
- `remote-exec` runs commands on EC2.
- `null_resource.post_deployment` waits for the EC2 instance through `depends_on`.

## Run The Demo

```bash
terraform init
terraform plan
terraform apply -auto-approve
```

Watch the terminal. Students should see Terraform run each provisioner in order.

## Verify local-exec

```bash
cat created_servers.log
```

Teaching line:

This file was created locally. It was not created inside EC2.

## Verify file And remote-exec

```bash
terraform output ssh_command
ssh -i ~/.ssh/demo-keypair.pem ec2-user@<public_ip>
ls -la /home/ec2-user/deploy.sh
cat /tmp/deploy.log
cat /tmp/setup_done.txt
exit
```

Open the web page:

```bash
echo "Open: http://$(terraform output -raw public_ip)"
```

## Ask Students

- What ran on the local machine?
- What ran on EC2?
- Why does the `file` provisioner need the `connection` block?
- What is the difference between putting `local-exec` inside `aws_instance` and using `null_resource`?

## Clean Up

```bash
terraform destroy -auto-approve
cat destroyed_servers.log
```

The destroy-time provisioner logs before Terraform destroys the EC2 instance.
