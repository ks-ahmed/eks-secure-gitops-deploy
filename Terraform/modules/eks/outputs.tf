output "cluster_name" {
  description = "EKS Cluster name"
  value       = aws_eks_cluster.this.name
}

output "cluster_endpoint" {
  description = "EKS Cluster endpoint"
  value       = aws_eks_cluster.this.endpoint
}

output "cluster_certificate_authority" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value = aws_eks_cluster.this.certificate_authority[0].data

}

output "cluster_security_group_id" {
  description = "Security group ID attached to EKS cluster control plane"
  value       = aws_security_group.eks_cluster_sg.id
}

output "node_group_name" {
  description = "EKS Node group name"
  value       = aws_eks_node_group.this.node_group_name
}

output "oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.oidc.arn
}
