# Get the Jenkins service data
data "kubernetes_service" "jenkins" {
  depends_on = [helm_release.jenkins]
  metadata {
    name = "jenkins"
    namespace = "jenkins"
  }
}

# Get the ArgoCD service data
data "kubernetes_service" "argocd" {
  depends_on = [helm_release.argocd]
  metadata {
    name = "argocd-server"
    namespace = "argocd"
  }
}


output "cluster_oidc_issuer_url" {
    description = "The URL on the EKS cluster OIDC Issuer"
    value       = module.eks.cluster_oidc_issuer_url
}

output "oidc_provider_arn" {
    description = "The ARN of the OIDC Provider if enabled"
    value       = module.eks.oidc_provider_arn
} 