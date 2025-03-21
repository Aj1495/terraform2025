# data "aws_lb" "shared_lb" {
#     depends_on = [helm_release.jenkins, helm_release.argocd]
#     tags = {
#         "kubernetes.io/cluster/${var.cluster_name}" = "owned"
#         "kubernetes.io/ingress-name"                = "jenkins/jenkins"
#     }
# }



# output "load_balancer_dns" {
#     value       = data.aws_lb.shared_lb.dns_name
#     description = "DNS name of the shared ALB"
# }
# data "external" "lb_dns" {
#     depends_on      = [helm_release.jenkins, helm_release.argocd]

#     program         = ["bash", "${path.module}/get_lb_dns.sh"]
# }

# output "load_balancer_dns" {
#     value           = data.external.lb_dns.result.lb_dns
#     description     = "DNS name of the shared Load Balancer"
# }


output "cluster_oidc_issuer_url" {
    description = "The URL on the EKS cluster OIDC Issuer"
    value       = module.eks.cluster_oidc_issuer_url
}

output "oidc_provider_arn" {
    description = "The ARN of the OIDC Provider if enabled"
    value       = module.eks.oidc_provider_arn
}