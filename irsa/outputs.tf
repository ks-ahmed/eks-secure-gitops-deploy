# outputs.tf

output "external_dns_irsa_role_arn" {
  description = "IAM Role ARN for ExternalDNS IRSA"
  value       = module.external_dns_irsa_role.iam_role_arn
}

output "cert_manager_irsa_role_arn" {
  description = "IAM Role ARN for Cert-Manager IRSA"
  value       = module.cert_manager_irsa_role.iam_role_arn
}
