module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "19.0.0"

  cluster_endpoint_private_access = false
  cluster_endpoint_public_access  = true

  cluster_name    = var.cluster_name
  cluster_version = "1.27"

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

      subnet_ids = var.private_subnet_ids

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