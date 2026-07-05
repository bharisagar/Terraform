resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = local.resource_names.vpc
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = local.resource_names.internet_gw
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = local.resource_names.public_subnet
    Tier = "public"
  }

  lifecycle {
    precondition {
      condition = join(".", slice(split(".", split("/", var.vpc_cidr)[0]), 0, 2)) == join(".", slice(split(".", split("/", var.public_subnet_cidr)[0]), 0, 2))

      error_message = "public_subnet_cidr must be a /24 subnet inside the /16 vpc_cidr, for example 10.20.1.0/24 inside 10.20.0.0/16."
    }
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = local.resource_names.route_table
    Tier = "public"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}
