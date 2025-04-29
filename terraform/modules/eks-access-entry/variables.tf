variable "eks_cluster_name" {
    description = "Name of EKS cluster within the VPC"
    type = string
}

variable "principal_arn" {
  description = "ARN of the IAM user who needs access to EKS"
  type        = string
}
