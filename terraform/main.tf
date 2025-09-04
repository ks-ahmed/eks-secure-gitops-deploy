# VPC module
module "vpc" {
  source          = "./modules/vpc"
  name            = var.name
  vpc_cidr        = var.vpc_cidr
  azs             = var.azs
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
}

module "iam" {
  source = "./modules/iam"

  name = var.name
  tags = var.common_tags
}


# EKS module
module "eks" {
  source               = "./modules/eks"
  name                 = var.name

  # VPC
  vpc_id               = module.vpc.vpc_id
  private_subnet_ids   = module.vpc.private_subnet_ids
  private_subnet_cidrs = var.private_subnet_cidrs

  # IAM Roles
  eks_cluster_role_arn = module.iam.eks_cluster_role_arn
  eks_node_role_arn    = module.iam.eks_node_role_arn
  cluster_version      = var.cluster_version




  # Optional tagging
  common_tags          = var.common_tags

  # ROOT-level dependency control
  depends_on = [
    module.vpc,
    module.iam
  ]
}

module "helm" {
  source = "./modules/helm"

  hosted_zone_id_labs   = var.hosted_zone_id_labs
  hosted_zone_id_k8s    = var.hosted_zone_id_k8s

  cert_manager_role_arn = module.irsa.cert_manager_irsa_role_arn
  external_dns_role_arn = module.irsa.external_dns_irsa_role_arn


  depends_on = [module.eks, module.irsa]
}

module "irsa" {
  source = "./modules/irsa"

  name                  = var.name
  eks_oidc_provider_arn = module.eks.oidc_provider_arn
  tags                  = var.common_tags
}