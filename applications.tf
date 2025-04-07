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
        serviceName = "jenkins"
        serviceAnnotations = {
          "alb.ingress.kubernetes.io/healthcheck-path" = "/login"
          "alb.ingress.kubernetes.io/healthcheck-port" = "8080"
          "alb.ingress.kubernetes.io/healthcheck-protocol" = "HTTP"
        }
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
        startupProbe = {
          enabled = true
          httpGet = {
            path = "/login"
            port = 8080
          }
          initialDelaySeconds = 300
          timeoutSeconds = 10
          periodSeconds = 30
          failureThreshold = 20
        }
        livenessProbe = {
          enabled = true
          httpGet = {
            path = "/login"
            port = 8080
          }
          initialDelaySeconds = 300
          timeoutSeconds = 10
          periodSeconds = 30
          failureThreshold = 20
        }
        readinessProbe = {
          enabled = true
          httpGet = {
            path = "/login"
            port = 8080
          }
          initialDelaySeconds = 300
          timeoutSeconds = 10
          periodSeconds = 30
          failureThreshold = 20
        }
        installPlugins = [
          "kubernetes:1.39.0",
          "workflow-aggregator:2.6",
          "git:5.0.0",
          "configuration-as-code:1.59"
        ]
        initializeOnce = true
        numExecutors = 2
        adminUser = "admin"
        adminPassword = "admin"
        overwritePlugins = true
        JCasC = {
          enabled = true
          configScripts = {
            welcome-message = "jenkins.systemMessage = 'Welcome to our CI/CD server. This Jenkins instance is managed as code.'"
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
          name = "argocd-server"
          annotations = {
            "alb.ingress.kubernetes.io/healthcheck-path" = "/"
            "alb.ingress.kubernetes.io/healthcheck-port" = "80"
            "alb.ingress.kubernetes.io/healthcheck-protocol" = "HTTP"
          }
        }
        ingress = {
          enabled = false
        }
        extraArgs = ["--basehref=/argocd", "--insecure"]
      }
    })
  ]
}