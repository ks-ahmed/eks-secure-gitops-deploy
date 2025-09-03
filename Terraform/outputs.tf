output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "eks_oidc_provider_arn" {
  value = module.eks.oidc_provider_arn
}

output "cert_manager_irsa_role_arn" {
  value = module.irsa.cert_manager_irsa_role_arn
}

output "external_dns_irsa_role_arn" {
  value = module.irsa.external_dns_irsa_role_arn
}
