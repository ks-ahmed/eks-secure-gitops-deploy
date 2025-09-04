# --- IRSA resources above ---

# Outputs for Helm / other modules
output "cert_manager_irsa_role_arn" {
  value = module.cert_manager_irsa_role.iam_role_arn
}

output "external_dns_irsa_role_arn" {
  value = module.external_dns_irsa_role.iam_role_arn
}
