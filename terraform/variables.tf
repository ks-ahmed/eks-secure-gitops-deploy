

variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-2"
}

variable "name" {
  description = "Base name prefix for resources (used in cluster, VPC, roles, etc.)"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "azs" {
  description = "List of availability zones to use"
  type        = list(string)
}

variable "public_subnets" {
  description = "List of public subnet CIDRs"
  type        = list(string)
}

variable "private_subnets" {
  description = "List of private subnet CIDRs"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "List of private subnet CIDRs (used for security group rules)"
  type        = list(string)
}

variable "hosted_zone_id_labs" {
  description = "Route53 hosted zone ID for ExternalDNS and CertManager"
  type        = string
}

variable "hosted_zone_id_k8s" {
  description = "Route53 hosted zone ID for ExternalDNS and CertManager"
  type        = string
}

variable "common_tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.29"   # or whichever version you want
}

variable "image_tag" {
  description = "Docker image tag to use in Kubernetes deployments"
  type        = string
  default     = "latest"
}
