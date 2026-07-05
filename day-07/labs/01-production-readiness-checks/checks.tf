check "remote_state_enabled" {
  assert {
    condition     = var.remote_state_enabled
    error_message = "Remote state should be enabled before production."
  }
}

check "state_locking_enabled" {
  assert {
    condition     = var.state_locking_enabled
    error_message = "State locking should be enabled before production."
  }
}

check "provider_versions_pinned" {
  assert {
    condition     = var.provider_versions_pinned
    error_message = "Provider versions should be pinned before production."
  }
}

check "secrets_reviewed" {
  assert {
    condition     = var.secrets_reviewed
    error_message = "Secrets and state exposure must be reviewed."
  }
}

check "least_privilege_iam" {
  assert {
    condition     = var.least_privilege_iam
    error_message = "Terraform should use least privilege IAM."
  }
}

check "plan_review_required" {
  assert {
    condition     = var.plan_review_required
    error_message = "Production applies should require plan review."
  }
}
