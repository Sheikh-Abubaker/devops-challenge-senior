output "eks_cluster_name" {
  description = "Name of EKS cluster within the VPC"
  value = aws_eks_cluster.eks.name
}

output "eks_oidc_url" {
    description = "EKS OIDC URL"
    value = aws_eks_cluster.eks.identity[0].oidc[0].issuer
}