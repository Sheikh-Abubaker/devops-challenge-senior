module "vpc" {
  source = "./modules/vpc"
}

module "subnet" {
  source = "./modules/subnet"
  vpc_id = module.vpc.vpc_id
  gateway_id = module.vpc.gateway_id

  depends_on = [module.vpc]
}

module "eks" {
    source = "./modules/eks"
    subnet_ids = module.subnet.subnet_ids

    depends_on = [module.subnet]
}

module "eks-access-entry" {
    source = "./modules/eks-access-entry"
    eks_cluster_name = module.eks.eks_cluster_name
    principal_arn = var.principal_arn

    depends_on = [module.eks]
}

module "aws-lb-controller" {
    source = "./modules/aws-lb-controller"
    aws_region = var.aws_region
    vpc_id = module.vpc.vpc_id
    eks_oidc_url = module.eks.eks_oidc_url

    depends_on = [module.eks-access-entry]
}

module "kubernetes" {
    source = "./modules/kubernetes"
    subnet_ids = module.subnet.subnet_ids

    depends_on = [module.aws-lb-controller]
}
