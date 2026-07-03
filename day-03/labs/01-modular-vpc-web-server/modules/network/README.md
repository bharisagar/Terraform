# Module: network

Creates a small public network for the Day 3 modular lab.

## Resources

- VPC.
- Public subnet.
- Internet gateway.
- Public route table.
- Route table association.

## Inputs

- `name_prefix`
- `vpc_cidr`
- `public_subnet_cidr`
- `common_tags`

## Outputs

- `vpc_id`
- `public_subnet_id`
- `availability_zone`
- `route_table_id`
