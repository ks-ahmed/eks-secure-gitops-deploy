variable "name" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "eks_oidc_provider_arn" {
  type = string
}
