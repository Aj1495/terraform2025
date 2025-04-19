variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "my-eks-cluster"
}

variable "node_instance_type" {
  description = "EC2 instance type for worker nodes"
  type        = string
  default     = "t3.large"
}

variable "jenkins_hostname" {
  description = "Hostname for Jenkins"
  type        = string
  default     = "jenkins.example.com"
}

variable "dns_hostname" {
  description = "DNS hostname for the shared ALB"
  type        = string
  default     = "apps.example.com"
}