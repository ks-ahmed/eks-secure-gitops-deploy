output "eks_cluster_id" {
  value = aws_eks_cluster.this.id
}

output "oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.oidc.arn
}


output "cluster_name" {
  value = aws_eks_cluster.this.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.this.endpoint
}

output "cluster_certificate_authority_data" {
  value = aws_eks_cluster.this.certificate_authority[0].data
}