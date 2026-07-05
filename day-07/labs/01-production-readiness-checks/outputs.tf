output "readiness_items" {
  description = "Production readiness checklist values."
  value       = local.readiness_items
}

output "readiness_score" {
  description = "Passed checks over total checks."
  value       = "${local.passed_count}/${local.total_count}"
}

output "production_hint" {
  description = "Final readiness guidance."
  value       = local.passed_count == local.total_count ? "Ready for review." : "Fix failed readiness items before production."
}
