locals {
  readiness_items = {
    remote_state_enabled     = var.remote_state_enabled
    state_locking_enabled    = var.state_locking_enabled
    provider_versions_pinned = var.provider_versions_pinned
    secrets_reviewed         = var.secrets_reviewed
    least_privilege_iam      = var.least_privilege_iam
    plan_review_required     = var.plan_review_required
  }

  passed_count = length([for _, passed in local.readiness_items : passed if passed])
  total_count  = length(local.readiness_items)
}
