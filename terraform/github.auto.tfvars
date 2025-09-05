# ---------------------------
# Cluster
# ---------------------------
name = "my-eks-cluster"

# ---------------------------
# VPC & Subnets
# ---------------------------
vpc_cidr            = "10.0.0.0/16"
public_subnets      = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
private_subnets     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
private_subnet_cidrs = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
azs                 = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]

# ---------------------------
# Hosted Zones for Cert-Manager
# ---------------------------
hosted_zone_id_labs = "Z00176861AUERXFO9TXIH"
hosted_zone_id_k8s  = "Z026106921D2B7DLNBJXV"

# ---------------------------
# Region
# ---------------------------
region = "eu-west-2"
