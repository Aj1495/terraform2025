module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "19.0.0"

  cluster_endpoint_private_access = false
  cluster_endpoint_public_access  = true

  cluster_name    = var.cluster_name
  cluster_version = "1.27"
  
  cluster_enabled_log_types = []  # Disable CloudWatch Logs temporarily

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_group_defaults = {
    instance_types = ["t3.large"]
  }

  eks_managed_node_groups = {
    default_node_group = {
      desired_size = 1
      min_size     = 1
      max_size     = 4

      instance_types = [var.node_instance_type]
      capacity_type  = "ON_DEMAND"

      disk_size = 50

      subnet_ids = module.vpc.private_subnets

      iam_role_arn = aws_iam_role.node_group_role.arn

      launch_template = {
        id            = null
        version       = null
        override = {
          instance_type     = var.node_instance_type
          network_interfaces  = [
            {
              associate_public_ip_address = false
            }
          ]
        }
      }
    }
  }
}

resource "null_resource" "apply_kubernetes_manifests" {
  depends_on = [
    # Add dependencies to your Terraform resources here, such as:
    # module.eks,
    # helm_release.jenkins,
    # helm_release.argocd,
    # or any other relevant resources that must be created first
  ]

  provisioner "local-exec" {
    command = <<-EOT
      kubectl apply -f ${path.module}/Ingress_Controller.yaml
      kubectl apply -f ${path.module}/Ingress_argocd.yaml -n argocd
      kubectl apply -f ${path.module}/Ingress_jenkins.yaml -n jenkins
    EOT
  }

  # This ensures the kubectl commands run every time Terraform applies changes
  triggers = {
    always_run = "${timestamp()}"
  }
}