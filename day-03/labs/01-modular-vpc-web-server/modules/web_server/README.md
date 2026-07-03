# Module: web_server

Creates a small public HTTP web server for the Day 3 modular lab.

## Resources

- Security group.
- HTTP ingress rule.
- All outbound egress rule.
- EC2 instance.

## Inputs

- `name_prefix`
- `vpc_id`
- `subnet_id`
- `http_ingress_cidr`
- `instance_type`
- `root_volume_size`
- `project_name`
- `environment`
- `aws_region`
- `common_tags`

## Outputs

- `security_group_id`
- `instance_id`
- `public_ip`
- `web_url`
- `ami_id`
