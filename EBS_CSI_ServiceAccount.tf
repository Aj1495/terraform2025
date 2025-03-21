#Create Kubernetes Service Account for EBS CSI Controller
resource "kubernetes_service_account" "ebs_csi_controller" {
    metadata {
        name        = "ebs-csi-controller-sa"
        namespace   = "kube-system"
        labels  = {
            "app.kubernetes.io/managed-by"  = "Helm"
        }
        annotations = {
            "eks.amazonaws.com/role-arn"        = aws_iam_role.ebs_csi_driver.arn
            "meta.helm.sh/release-name"         = "aws-ebs-csi-driver"
            "meta.helm.sh/release-namespace"    = "kube-system"
        }
    }
}