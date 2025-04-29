variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID to set in AWS Load Balancer Controller Helm Release"
  type        = string
}

variable "eks_oidc_url" {
    description = "EKS OIDC URL"
    type = string
}