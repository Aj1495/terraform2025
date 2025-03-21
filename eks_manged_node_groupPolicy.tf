resource "aws_iam_role" "node_group_role" {
    name    = "${var.cluster_name}-node-group-role"

    assume_role_policy  = data.aws_iam_policy_document.node_assume_role_policy.json

    tags    = {
        "Name"  = "${var.cluster_name}-node-group-role"
    }
}

resource "aws_iam_role_policy_attachment" "node_group_role_attachment" {
    for_each    = {
        "AmazonEKSWorkerNodePolicy"             = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
        "AmazonEKS_CNI_Policy"                  = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
        "AmazonEC2ContainerRegistryReadOnly"    = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"   
    }
    
    role        = aws_iam_role.node_group_role.name
    policy_arn  = each.value
}