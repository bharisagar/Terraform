data "aws_caller_identity" "current" {}

module "network" {
  source = "./modules/network"

  common_tags        = local.common_tags
  name_prefix        = local.name_prefix
  public_subnet_cidr = var.public_subnet_cidr
  vpc_cidr           = var.vpc_cidr
}

module "web_server" {
  source = "./modules/web_server"

  aws_region        = var.aws_region
  common_tags       = local.common_tags
  environment       = var.environment
  http_ingress_cidr = var.http_ingress_cidr
  instance_type     = var.instance_type
  name_prefix       = local.name_prefix
  project_name      = var.project_name
  root_volume_size  = var.root_volume_size
  subnet_id         = module.network.public_subnet_id
  vpc_id            = module.network.vpc_id
}
