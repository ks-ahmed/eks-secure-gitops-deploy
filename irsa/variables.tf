# variables.tf

variable "name" {
  description = "Base name prefix for resources"
  type        = string
}

variable "hosted_zone_arn" {
  description = "ARN of the Route53 hosted zone"
  type        = string
}

variable "oidc_provider_arn" {
  description = "OIDC Provider ARN from EKS cluster"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all IAM roles"
  type        = map(string)
  default     = {}
}
