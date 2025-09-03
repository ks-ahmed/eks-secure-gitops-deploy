variable "cert_manager_role_arn" {
  description = "IAM Role ARN for Cert-Manager service account"
  type        = string
}


variable "external_dns_role_arn" {
  description = "IAM Role ARN for ExternalDNS IRSA"
  type        = string
}

variable "hosted_zone_id_labs" {
  description = "Route53 Hosted Zone ID for labs domain"
  type        = string
}

variable "hosted_zone_id_k8s" {
  description = "Route53 Hosted Zone ID for k8s domain"
  type        = string
}
