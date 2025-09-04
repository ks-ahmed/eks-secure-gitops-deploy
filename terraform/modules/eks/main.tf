# ---------------------------
# Security Groups
# ---------------------------
resource "aws_security_group" "eks_cluster_sg" {
  name        = "${var.name}-eks-cluster-sg"
  description = "EKS control plane SG"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow worker nodes to communicate with cluster"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.private_subnet_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, { Name = "${var.name}-eks-cluster-sg" })
}

resource "aws_security_group" "eks_node_sg" {
  name        = "${var.name}-eks-node-sg"
  description = "EKS worker nodes SG"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow node to node communication"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    self        = true
  }

  ingress {
    description = "Allow nodes to communicate with control plane"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.private_subnet_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, { Name = "${var.name}-eks-node-sg" })
}

# ---------------------------
# EKS Cluster
# ---------------------------
resource "aws_eks_cluster" "this" {
  name     = var.name
  version  = var.cluster_version
  role_arn = var.eks_cluster_role_arn

  vpc_config {
    subnet_ids         = var.private_subnet_ids
    security_group_ids = [aws_security_group.eks_cluster_sg.id]
  }

  tags = merge(var.common_tags, { Project = var.name })
}

# ---------------------------
# OIDC Provider for IRSA
# ---------------------------
data "tls_certificate" "oidc_thumbprint" {
  url = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "oidc" {
  url             = aws_eks_cluster.this.identity[0].oidc[0].issuer
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.oidc_thumbprint.certificates[0].sha1_fingerprint]
}

# ---------------------------
# EKS Node Group
# ---------------------------
resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.name}-nodes"
  node_role_arn   = var.eks_node_role_arn
  subnet_ids      = var.private_subnet_ids

  scaling_config {
    desired_size = var.desired_capacity
    max_size     = var.max_size
    min_size     = var.min_size
  }

  instance_types = [var.node_instance_type]
  ami_type       = "AL2_x86_64"
  capacity_type  = "ON_DEMAND"

  tags = merge(var.common_tags, { Project = var.name })

  depends_on = [
    aws_eks_cluster.this
  ]
}
