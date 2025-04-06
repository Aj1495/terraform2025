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
   })
  ]

  set {
    name  = "controller.serviceType"
    value = "ClusterIP"
  }

  set {
    name  = "controller.ingress.annotations.alb\\.ingress\\.kubernetes\\.io/subnets"
    value = "${replace("subnet-055bdb06e6d448f34,subnet-0d9dece2732432440", ",", "\\,")}"
  }

  set {
    name  = "controller.startupProbe.enabled"
    value = "false"
  }

  set {
    name  = "controller.ingress.enabled"
    value = "false"
  }

  set {
    name  = "service.ports[0].name"
    value = "http"
  }

  set {
    name  = "service.ports[1].name"
    value = "https"
  }

  set {
    name  = "controller.jenkinsUriPrefix"
    value = "/jenkins"
  }

  set {
    name  = "controller.jenkinsUrl"
    value = "/jenkins"
  }

  set {
    name  = "controller.jenkins.agentProtocol"
    value = "[\"JNLP4-connect\"]"
  }

  set {
    name  = "controller.resources.requests.cpu"
    value = "600m"
  }

  set {
    name  = "conroller.resources.requests.memory"
    value = "1Gi"
  }

  set {
    name  = "controller.resources.limits.cpu"
    value = "1"
  }

  set {
    name  = "controller.resources.limits.memory"
    value = "2Gi"
  }
}

resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true

  set {
    name  = "server.service.type"
    value = "ClusterIP"
  }

  set {
    name  = "server.ingress.enabled"
    value = "false"
  }

  set {
    name  = "server.extraArgs"
    value = "{--basehref=/argocd,--insecure}"
  }

  set {
    name  = "server.ingress.paths[0]"
    value = "/argocd"
  }

  set {
    name  = "server.ingress.hosts[0]"
    value = ""
  }
  set {
    name  = "server.ingress.annotations.kubernetes\\.io/ingress\\.class"
    value = "alb"
  }

  set {
    name  = "server.ingress.annotations.alb\\.ingress\\.kubernetes\\.io/scheme"
    value = "internet-facing"
  }
  set {
    name  = "server.ingress.annotations.alb\\.ingress\\.kubernetes\\.io/load-balancer-attributes"
    value = "load_balancing.cross_zone.enabled=true"
  }
  set {
    name  = "server.ingress.annotations.alb\\.ingress\\.kubernetes\\.io/target-type"
    value = "ip"
  }
  set {
    name  = "server.ingress.annotations.alb\\.ingress\\.kubernetes\\.io/group\\.name"
    value = "shared-alb"
  }
  set {
    name  = "server.ingress.annotations.alb\\.ingress\\.kubernetes\\.io/subnets"
    value = yamlencode(["subnet-055bdb06e6d448f34", "subnet-0d9dece2732432440"])
  }
}