resource "kubernetes_manifest" "shared_ingress" {
  depends_on = [helm_release.jenkins, helm_release.argocd]
  manifest = yamldecode(file("${path.module}/ingress.yaml"))
}

resource "kubernetes_manifest" "cross_namespace_ingress" {
  depends_on = [helm_release.jenkins, helm_release.argocd]
  manifest = yamldecode(file("${path.module}/cross-namespace-ingress.yaml"))
}
