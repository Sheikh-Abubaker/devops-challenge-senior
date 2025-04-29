resource "aws_iam_role" "eks_role" {
  name = "primary-eks-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "eks.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_role.name
}

resource "aws_eks_cluster" "eks" {
  name = "Simple-Time-Service-EKS-Cluster"

  access_config {
    authentication_mode = "API_AND_CONFIG_MAP"
  }

  role_arn = aws_iam_role.eks_role.arn
  version  = "1.32"

  vpc_config {
    subnet_ids = var.subnet_ids
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy,
    aws_iam_role.fargate_pod_execution_role
  ]
}

resource "aws_iam_role" "fargate_pod_execution_role" {
  name = "fargate-pod-execution-role"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks-fargate-pods.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "fargate_profile_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  role       = aws_iam_role.fargate_pod_execution_role.name
}

resource "aws_eks_fargate_profile" "eks_fargate_private1" {
  cluster_name           = aws_eks_cluster.eks.name
  fargate_profile_name   = "SimpleTS-EKS-Cluster-Subnet-Private1-us-east-1a"
  pod_execution_role_arn = aws_iam_role.fargate_pod_execution_role.arn
  subnet_ids             = [var.subnet_ids[3]]

  selector {
    namespace = "default"
  }

  selector {
    namespace = "kube-system"
  }

  selector {
    namespace = "app"
  }
}

resource "aws_eks_fargate_profile" "eks_fargate_private2" {
  cluster_name           = aws_eks_cluster.eks.name
  fargate_profile_name   = "SimpleTS-EKS-Cluster-Subnet-Private1-us-east-1b"
  pod_execution_role_arn = aws_iam_role.fargate_pod_execution_role.arn
  subnet_ids             = [var.subnet_ids[1]]

  selector {
    namespace = "default"
  }

  selector {
    namespace = "kube-system"
  }

  selector {
    namespace = "app"
  }
}
