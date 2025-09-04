# NGINX Ingress
resource "helm_release" "nginx_ingress" {
  name             = "nginx-ingress"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "nginx-ingress"
  create_namespace = true

  values = [file("helm-values/nginx.yaml")]
}

# Cert Manager
resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  version          = "v1.16.2"
  namespace        = "cert-manager"
  create_namespace = true

  set = [
  {
    name  = "crds.enabled"
    value = "true"
  }

  ]

  values = [
    file("helm-values/cert-manager.yaml"),
    yamlencode({
      serviceAccount = {
        annotations = {
          "eks.amazonaws.com/role-arn" = var.cert_manager_role_arn
        }
      }
    })
  ]

    depends_on = [helm_release.nginx_ingress] # only after ingress

}



# ExternalDNS
resource "helm_release" "external_dns" {
  name             = "external-dns"
  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "external-dns"
  namespace        = "external-dns"
  create_namespace = true

  values = [
    file("helm-values/external-dns.yaml"),
    yamlencode({
      serviceAccount = {
        annotations = {
          "eks.amazonaws.com/role-arn" = var.external_dns_role_arn
        }
      }
    })
  ]

  depends_on = [helm_release.nginx_ingress]
}




# ArgoCD
resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argo-cd"
  create_namespace = true

  values = [
    file("helm-values/argo-cd.yaml")
  ]


  depends_on = [
    helm_release.cert_manager,
    helm_release.nginx_ingress,
    helm_release.external_dns
  ]
}

# Prometheus/Grafana
resource "helm_release" "kube_prom_stack" {
  name             = "monitoring-stack"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  namespace        = "monitoring"
  create_namespace = true

  values = [
    file("helm-values/prom-grafana.yaml")
  ]

  depends_on = [
    helm_release.cert_manager,
    helm_release.nginx_ingress,
    helm_release.external_dns
  ]
}
