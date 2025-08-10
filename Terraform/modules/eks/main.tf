resource "aws_security_group" "eks_cluster_sg" {
  name        = "${var.name}-eks-cluster-sg"
  description = "Security group for EKS cluster control plane"
  vpc_id      = var.vpc_id

  # Allow inbound traffic from worker nodes to the cluster on required ports
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    description = [var.worker_node_cidr] # e.g., the CIDR range of your worker nodes or private subnet CIDRs
  }

  # Allow outbound all traffic (to worker nodes and internet)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Project = var.name
  }
}

resource "aws_security_group" "eks_node_sg" {
  name        = "${var.name}-eks-node-sg"
  description = "Security group for EKS worker nodes"
  vpc_id      = var.vpc_id

  # Allow nodes to communicate with the cluster API server
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    description = "Allow nodes to communicate with EKS API server"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow node port range (30000-32767) for Kubernetes services of type NodePort
  ingress {
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    description = "Allow NodePort services"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all traffic between nodes
  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    self            = true
    description     = "Allow all node-to-node communication"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Project = var.name
  }
}

resource "aws_eks_cluster" "this" {
  name     = var.name
  version  = var.cluster_version
  role_arn = var.eks_cluster_role_arn

  vpc_config {
    subnet_ids         = var.private_subnet_ids
    security_group_ids = [aws_security_group.eks_cluster_sg.id]
  }

  tags = {
    Project = var.name
  }
}

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
  
  depends_on = [
    aws_eks_cluster.this
  ]

  tags = {
    Project = var.name
  }

  
}