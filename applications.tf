resource "helm_release" "jenkins" {
  depends_on       = [
    helm_release.aws_load_balancer_controller,
    helm_release.aws_ebs_csi_driver
  ]
  name             = "jenkins"
  repository       = "https://charts.jenkins.io"
  chart            = "jenkins"
  namespace        = "jenkins"
  version          = "5.7.0"
  create_namespace = true
  values  = [
    yamlencode({
      persistence = {
        enabled       = true
        storageClass  = "gp2"
        size          = "7Gi"
      }
      controller = {
        serviceType = "ClusterIP"
        servicePort = 8080
        ingress = {
          enabled = false
        }
        jenkinsUriPrefix = "/jenkins"
        jenkinsUrl = "/jenkins"
        agentProtocol = ["JNLP4-connect"]
        resources = {
          requests = {
            cpu = "600m"
            memory = "1Gi"
          }
          limits = {
            cpu = "1"
            memory = "2Gi"
          }
        }
      }
    })
  ]
}

resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true
  values = [
    yamlencode({
      server = {
        service = {
          type = "ClusterIP"
          port = 80
        }
        ingress = {
          enabled = false
        }
        extraArgs = ["--basehref=/argocd", "--insecure"]
      }
    })
  ]
}