# Cert-Manager IRSA Role
module "cert_manager_irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.52.2"

  role_name = "${var.name}-cert-manager-role"

  oidc_providers = {
    eks = {
      provider_arn               = var.eks_oidc_provider_arn
      namespace_service_accounts = ["cert-manager:cert-manager"]
    }
  }

  tags = var.tags
}

# Minimal Route53 policy for cert-manager DNS01 challenges
resource "aws_iam_policy" "cert_manager_route53" {
  name        = "${var.name}-cert-manager-route53"
  description = "Cert-manager Route53 access for DNS01"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "route53:ListHostedZones",
          "route53:ListHostedZonesByName",
          "route53:GetChange",
          "route53:ChangeResourceRecordSets",
          "route53:ListResourceRecordSets"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cert_manager_route53_attachment" {
  role       = module.cert_manager_irsa_role.iam_role_name
  policy_arn = aws_iam_policy.cert_manager_route53.arn
}


# ExternalDNS IRSA Role
module "external_dns_irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.52.2"

  role_name = "${var.name}-external-dns-role"

  oidc_providers = {
    eks = {
      provider_arn               = var.eks_oidc_provider_arn
      namespace_service_accounts = ["external-dns:external-dns"]
    }
  }

  tags = var.tags
}

# Minimal Route53 policy for ExternalDNS
resource "aws_iam_policy" "external_dns_route53" {
  name        = "${var.name}-external-dns-route53"
  description = "ExternalDNS Route53 access"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "route53:ListHostedZones",
          "route53:ListHostedZonesByName",
          "route53:GetChange",
          "route53:ChangeResourceRecordSets",
          "route53:ListResourceRecordSets"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "external_dns_route53_attachment" {
  role       = module.external_dns_irsa_role.iam_role_name
  policy_arn = aws_iam_policy.external_dns_route53.arn
}
