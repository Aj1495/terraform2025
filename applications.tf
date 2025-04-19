resource "helm_release" "jenkins" {
  depends_on       = [
    helm_release.aws_ebs_csi_driver
  ]
  name             = "jenkins"
  repository       = "https://charts.jenkins.io"
  chart            = "jenkins"
  namespace        = "jenkins"
  version          = "5.7.0"
  create_namespace = true
  timeout          = 600
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
        ingress = {
          enabled = false
        }
        jenkinsUriPrefix = "/jenkins"
        jenkinsUrl = "/jenkins"
        containerEnv = [
          {
            name = "JENKINS_OPTS"
            value = "--prefix=/jenkins"
          }
        ]
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
          "kubernetes",
          "workflow-aggregator:2.6",
          "git:5.0.0",
          "configuration-as-code:1836.vccda_4a_122a_a_e"
        ]
        initializeOnce = true
        numExecutors = 2
        admin = {
          username = "admin"
          password = "admin"
        }
        overwritePlugins = true
        JCasC = {
          enabled = true
          configScripts = {
            welcome-message = <<-EOT
              jenkins:
                systemMessage: "Welcome to our CI/CD server. This Jenkins instance is managed as code."
            EOT
          }
        }
        initScripts = [
          "echo 'Starting Jenkins initialization...'",
          "echo 'Waiting for Jenkins to be ready...'"
        ]
        disableRememberMe = true
        disableSetupWizard = true
        javaOpts = "-Djenkins.install.runSetupWizard=false -Djava.awt.headless=true -Dhudson.model.DirectoryBrowserSupport.CSP=\"\""
        securityRealm = {
          local = {
            allowsSignup = false
            users = [
              {
                id = "admin"
                password = "admin"
              }
            ]
          }
        }
        authorizationStrategy = {
          loggedInUsersCanDoAnything = {
            allowAnonymousRead = false
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
        }
        ingress = {
          enabled = false
        }
        extraArgs = ["--rootpath", "/argocd", "--insecure"]
      }
    })
  ]
}