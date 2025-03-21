data "aws_eks_cluster" "cluster" {
    name = module.eks.cluster_name

    depends_on = [module.eks]
}
data "aws_eks_cluster_auth" "cluster" {
    name = module.eks.cluster_name

    depends_on = [module.eks]
}
data "aws_iam_policy_document" "node_assume_role_policy" {
    statement {
        effect  = "Allow"


        principals {
            type        = "Service"
            identifiers = ["ec2.amazonaws.com"]
        }

        actions = ["sts:AssumeRole"]
    }
}