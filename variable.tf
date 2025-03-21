# variables.tf

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

# variable "cluster_oidc_issuer_url" {
#   description = "EKS cluster OIDC issuer URL"
#   type        = string
# }

# variable "cluster_oidc_provider_arn" {
#   description = "EKS cluster OIDC provider ARN"
#   type        = string
# }

variable "vpc_id" {
  description = "VPC ID where EKS will be deployed"
  type        = string
  default     = "vpc-0a1b2c4d5e6f7a8b"
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
  default     = ["subnet-1234abcd", "subnet-5678efgh"]
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
  default     = ["subnet-9101ijkl", "subnet-1213mnop"]
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