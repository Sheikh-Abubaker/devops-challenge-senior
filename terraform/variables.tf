variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
}

variable "config_path" {
  description = "kubeconfig file path for Kubernetes client"
  type        = string
}

variable "principal_arn" {
  description = "ARN of the IAM user who needs access to EKS"
  type        = string
}
