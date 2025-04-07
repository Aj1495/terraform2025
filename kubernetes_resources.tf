resource "kubernetes_manifest" "shared_ingress" {
  depends_on = [helm_release.jenkins, helm_release.argocd]
  manifest = yamldecode(file("${path.module}/ingress.yaml"))
}
