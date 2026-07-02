resource "aws_instance" "web" {
  ami                         = data.aws_ami.amazon_linux_2023.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.web.id]
  associate_public_ip_address = true
  monitoring                  = false
  user_data = templatefile("${path.module}/user_data.sh.tftpl", {
    environment  = var.environment
    project_name = var.project_name
    region       = var.aws_region
  })
  user_data_replace_on_change = true

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  root_block_device {
    encrypted   = true
    volume_size = var.root_volume_size
    volume_type = "gp3"
  }

  tags = {
    Name = local.resource_names.instance
  }

  depends_on = [aws_route_table_association.public]
}
