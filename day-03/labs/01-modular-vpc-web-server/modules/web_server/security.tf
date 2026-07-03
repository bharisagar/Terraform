resource "aws_security_group" "web" {
  name_prefix = "${var.name_prefix}-web-"
  description = "Allow HTTP to Day 3 modular web server"
  vpc_id      = var.vpc_id

  tags = merge(var.common_tags, {
    Name = "${var.name_prefix}-web-sg"
  })

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.web.id
  description       = "Allow HTTP from configured CIDR"
  cidr_ipv4         = var.http_ingress_cidr
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "all_ipv4" {
  security_group_id = aws_security_group.web.id
  description       = "Allow all outbound IPv4 traffic"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
