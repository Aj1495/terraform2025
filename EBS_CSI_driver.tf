resource "helm_release" "aws_ebs_csi_driver" {
    name        = "aws-ebs-csi-driver"
    repository  = "https://kubernetes-sigs.github.io/aws-ebs-csi-driver"
    chart       = "aws-ebs-csi-driver"
    namespace   = "kube-system"
    version     = "2.20.0"
    set {
        name    = "enableVolumeScheduling"
        value   = "true"
    }
    set {
        name    = "enableVolumeResizing"
        value   = "true"
    }
    set {
        name    = "enableVolumeSnapshot"
        value   = "true"
    }

    values  = [
        yamlencode({
            enableVolumeScheduling  = true
            enableVolumeResizing    = true
            enableVolumeSnapshot    = false

            region  = var.aws_region

            serviceAccount = {
                create  = false
                name    = kubernetes_service_account.ebs_csi_controller.metadata[0].name
            }
        })
    ]

    depends_on  = [
        kubernetes_service_account.ebs_csi_controller,
        aws_iam_role_policy_attachment.ebs_csi_driver
    ]

}