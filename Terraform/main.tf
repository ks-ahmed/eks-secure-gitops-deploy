module "vpc" {
  source           = "./vpc"
  name             = var.name
  vpc_cidr         = var.vpc_cidr
  azs              = var.azs
  public_subnets   = var.public_subnets
  private_subnets  = var.private_subnets
}

module "iam" {
  source = "./modules/iam"
  name   = var.name
}

module "eks" {
  source               = "./modules/eks"
  name                 = var.name
  private_subnet_ids   = module.vpc.private_subnet_ids
  eks_cluster_role_arn = module.iam.eks_cluster_role_arn
  eks_node_role_arn    = module.iam.eks_node_role_arn
  worker_node_cidr    = var.private_subnet_cidrs
  vpc_id              = module.vpc.vpc_id


}
