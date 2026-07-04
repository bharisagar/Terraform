# Day 5: Provisioning, User Data, and App Bootstrap

Welcome to Day 5.

Day 5 answers a practical question: after Terraform creates infrastructure, how does software get installed and started?

The professional answer is not always "use Terraform provisioners." Terraform is best at creating infrastructure. Application configuration is often better handled by user data, cloud-init, golden AMIs, AWS Systems Manager, Ansible, CI/CD, containers, or configuration management tools.

But students still need to understand provisioners because they appear in real codebases and interviews.

## Day 5 Outcome

By the end of Day 5, you should be able to:

- Explain why provisioners are a last resort.
- Use EC2 user data for first-boot bootstrap.
- Explain `local-exec`, `remote-exec`, and `file` provisioners.
- Understand when provisioners run.
- Use the `self` object inside a provisioner.
- Understand `when` and `on_failure` provisioner arguments.
- Explain the security risks of SSH-based remote provisioning.
- Build a visible web app bootstrapped by user data.

## The Provisioning Problem

Terraform can create an EC2 instance.

But an empty EC2 instance is not an application.

Someone still needs to:

- Install packages.
- Write configuration files.
- Start services.
- Register the app somewhere.
- Verify it is healthy.

There are many ways to do this. Terraform provisioners are only one option.

## Preferred Bootstrap Options

Use these before provisioners whenever possible:

| Option | Good For |
| --- | --- |
| EC2 user data / cloud-init | First boot setup for simple instances |
| Golden AMI with Packer | Repeatable prebuilt servers |
| AWS Systems Manager | Managed commands without SSH exposure |
| Containers | App packaging with ECS, EKS, or Docker |
| Configuration management | Ongoing server configuration |
| CI/CD pipeline | App deployment after infrastructure exists |

Day 5 rule:

Use Terraform to create infrastructure. Use the best-purpose tool to configure applications.

## Terraform Provisioners

Terraform includes built-in provisioners for post-create operations:

| Provisioner | What It Does |
| --- | --- |
| `local-exec` | Runs a command on the machine running Terraform |
| `remote-exec` | Runs commands on the remote resource over SSH or WinRM |
| `file` | Copies files to a remote resource |

Provisioners run during resource creation by default.

They can also run during destroy with:

```hcl
provisioner "local-exec" {
  when    = destroy
  command = "echo destroying ${self.id}"
}
```

## Why Provisioners Are Risky

Provisioners are harder for Terraform to model than normal resources.

Problems include:

- Commands can succeed once and fail later.
- A command may change something Terraform cannot track.
- SSH access needs keys, users, ports, and network paths.
- Failed provisioners can leave partially configured resources.
- Re-running provisioners is not as clean as updating Terraform resources.
- Secrets may leak through commands, logs, or connection blocks.

Use them only when the cleaner options do not fit.

## `local-exec`

`local-exec` runs on the machine where Terraform runs.

Examples:

- Write a local deployment note.
- Trigger a local script.
- Call a CLI after resource creation.
- Send a notification.

Example:

```hcl
resource "terraform_data" "example" {
  input = "hello"

  provisioner "local-exec" {
    command = "echo created"
  }
}
```

## `remote-exec`

`remote-exec` connects to a server and runs commands there.

It requires a `connection` block:

```hcl
connection {
  type        = "ssh"
  user        = "ec2-user"
  private_key = file(var.private_key_path)
  host        = self.public_ip
}
```

Remote execution usually means you opened SSH and handled credentials. That is why we avoid it in beginner AWS labs unless there is a strong reason.

## The `self` Object

Inside a provisioner, use `self` to refer to the parent resource.

Example:

```hcl
provisioner "local-exec" {
  command = "echo ${self.id}"
}
```

Do not reference the parent resource by full name inside its own provisioner. Use `self` to avoid dependency cycle problems.

## Failure Behavior

Provisioners support `on_failure`.

```hcl
provisioner "local-exec" {
  command    = "some-command"
  on_failure = fail
}
```

Common options:

| Value | Meaning |
| --- | --- |
| `fail` | Mark the apply as failed |
| `continue` | Continue even if command fails |

Use `continue` carefully. It can hide broken setup.

## User Data

EC2 user data runs when an instance first boots.

For simple bootstrap, user data is usually better than SSH provisioners because:

- Terraform does not need to SSH into the server.
- No private key is needed in Terraform.
- No inbound SSH rule is needed.
- The instance configures itself during boot.
- The setup is visible in the launch configuration.

Day 5 AWS lab uses user data for this reason.

## Day 5 Labs

### Lab 00: Local Exec Provisioner Demo

Path:

```text
day-05/labs/00-local-exec-provisioner
```

This lab uses `terraform_data` and `local-exec` to show provisioner behavior safely on your local machine.

### Lab 01: EC2 User Data Web App

Path:

```text
day-05/labs/01-ec2-user-data-web-app
```

This lab creates an EC2 instance that installs and starts Apache through user data. It opens HTTP but not SSH.

## Professional Habits For Day 5

- Prefer user data, cloud-init, AMIs, SSM, containers, or CI/CD over provisioners.
- Avoid SSH-based provisioning unless there is a strong reason.
- Never put private keys in committed Terraform code.
- Keep provisioner commands small and auditable.
- Use `on_failure = fail` unless you intentionally accept partial setup.
- Make bootstrap scripts idempotent where possible.
- Destroy learning resources when finished.

## Day 5 Completion Checklist

You are done with Day 5 when you can answer these:

- Why are provisioners considered a last resort?
- What is the difference between `local-exec` and `remote-exec`?
- Why is user data safer than SSH provisioning for simple EC2 bootstrap?
- What does the `self` object mean?
- When does a provisioner run by default?
- What does `on_failure = continue` risk hiding?
- Why should SSH stay closed in beginner public web labs?
