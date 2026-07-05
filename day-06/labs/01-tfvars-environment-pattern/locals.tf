locals {
  name_prefix = "${var.project_name}-${var.environment}"

  release_policy = var.environment == "prod" ? "manual-approval-required" : "fast-feedback"

  environment_summary = {
    name                       = var.environment
    instance_type              = var.instance_type
    desired_capacity           = var.desired_capacity
    deletion_protection        = var.enable_deletion_protection
    release_policy             = local.release_policy
    example_autoscaling_group  = "${local.name_prefix}-asg"
    example_load_balancer_name = "${local.name_prefix}-alb"
  }
}
