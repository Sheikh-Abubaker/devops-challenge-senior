resource "aws_eks_access_entry" "iam_entity_eks_access_entry" {
  cluster_name  = var.eks_cluster_name
  principal_arn = var.principal_arn
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "iam_entity_eks_admin_access" {
  cluster_name  = var.eks_cluster_name
  principal_arn = var.principal_arn
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  access_scope {
    type = "cluster"
  }
  depends_on = [aws_eks_access_entry.iam_entity_eks_access_entry]
}
