module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "19.0.0"
  cluster_name    = var.cluster_name
  cluster_version = "1.27"
  
  vpc_id          = var.vpc_id
  subnet_ids      = concat(
    var.private_subnet_ids,
    var.public_subnet_ids
  )

  cluster_endpoint_public_access = true
  cluster_endpoint_private_access = false

  eks_managed_node_groups  = {
      default_node_group  = {
        disk_size = 50
        instance_types   = [var.node_instance_type]
        desired_size = 1
        min_size     = 1
        max_size     = 4

        capacity_type   = "ON_DEMAND" 
        iam_role_arn    = aws_iam_role.node_group_role.arn
        subnet_ids      = var.private_subnet_ids
      # scaling_config  = {
      #   desired_size  = 2
      #   min_size      = 1
      #   max_size      = 3
      # }

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