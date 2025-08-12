
resource "helm_release" "nginx_ingress" {
  name             = "nginx-ingress"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "nginx-ingress"
  create_namespace = true
  timeout          = 300

  depends_on = [
    module.eks
  ]
}


resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  namespace        = "cert-manager"
  create_namespace = true
  timeout          = 300

  set {
    name  = "installCRDs"
    value = "true"
  }

  values = [
    file("${path.module}/helm-values/cert-manager.yaml")
  ]

  depends_on = [
    helm_release.nginx_ingress,
    module.cert_manager_irsa_role
  ]
}


resource "helm_release" "external_dns" {
  name             = "external-dns"
  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "external-dns"
  namespace        = "external-dns"
  create_namespace = true
  timeout          = 300

  values = [
    file("${path.module}/helm-values/external-dns.yaml")
  ]

  depends_on = [
    helm_release.nginx_ingress,
    module.external_dns_irsa_role
  ]
}


resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true

  values = [
    file("${path.module}/helm-values/argo-cd.yaml")
  ]

  depends_on = [
    aws_eks_node_group.this,
    helm_release.nginx_ingress
  ]
}

resource "helm_release" "kube_prom_stack" {
  name             = "monitoring-stack"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  namespace        = "monitoring"
  create_namespace = true
  timeout          = 600

  values = [
    file("${path.module}/helm-values/prom-grafana.yaml")
  ]

  depends_on = [
    helm_release.nginx_ingress,
    helm_release.cert_manager,
    helm_release.external_dns
  ]
}
