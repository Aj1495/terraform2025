resource "helm_release" "aws_load_balancer_controller" {
  depends_on       = [module.eks]
  name             = "aws-load-balancer-controller"
  repository       = "https://aws.github.io/eks-charts"
  chart            = "aws-load-balancer-controller"
  namespace        = "kube-system"
  create_namespace = false

  set {
    name  = "clusterName"
    value = var.cluster_name
  }

  set {
    name  = "region"
    value = var.aws_region
  }

  set {
    name  = "serviceAccount.create"
    value = false
  }
  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }
  
}

resource "kubernetes_service_account" "aws_lb_controller_sa" {
    metadata {
        name        = "aws-load-balancer-controller"
        namespace   = "kube-system"
        annotations = {
            "eks.amazonaws.com/role-arn" = aws_iam_role.aws_lb_controller.arn
        }
    }
}

resource "aws_iam_role" "aws_lb_controller" {
    name    = "${var.cluster_name}-aws-lb-controller"
    assume_role_policy = data.aws_iam_policy_document.aws_lb_assume_role_policy.json
}
# Data block for IAM policy document
data "aws_iam_policy_document" "aws_lb_assume_role_policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "Federated"
      identifiers = [module.eks.oidc_provider_arn]
    }
    actions = ["sts:AssumeRoleWithWebIdentity"]
    
    condition {
      test     = "StringEquals"
      variable = "${replace(module.eks.cluster_oidc_issuer_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:aws-load-balancer-controller"]
    }
    # condition {
    #   test     = "StringEquals"
    #   variable = "${replace(module.eks.oidc_provider_arn, "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/", "")}"
    #   values   = ["system:serviceaccount:kube-system:aws-load-balancer-controller"]
    # }
  }
}

resource "aws_iam_policy" "aws_lb_controller_policy" {
  name   = "${var.cluster_name}-aws-lb-controller-policy"
  policy = file("iam_policy.json")  # Ensure this file exists with the appropriate policy
}

resource "aws_iam_role_policy_attachment" "aws_lb_controller_attachment" {
  role        = aws_iam_role.aws_lb_controller.name 
  policy_arn  = aws_iam_policy.aws_lb_controller_policy.arn
}
# resource "aws_subnet" "public" {
#   vpc_id  = var.vpc_id
#   for_each  = toset(var.public_subnet_ids)
#   cidr_block  = each.value

#   tags  = {
#     "kubernetes.io/role/elb"  = "1"
#   }
# }

# resource "aws_subnet" "private" {
#   vpc_id  = var.vpc_id
#   for_each  = toset(var.private_subnet_ids)
#   cidr_block  = each.value

#   tags  = {
#     "kubernetes.io/role/internal-elb"  = "1"
#   }
# }

data "aws_caller_identity" "current" {}