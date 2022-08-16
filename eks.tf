module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 18.0"

  cluster_name    = "simple-jwt-api"
  cluster_version = "1.22"

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  cluster_addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {}
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
    }
  }
  vpc_id     = "vpc-075657539bc01320b"
  subnet_ids = ["subnet-06da6cc7d84274b9d", "subnet-09affd3a4b9dd74d5", "subnet-0fe0521914bfd495d"]

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    disk_size      = 50
    instance_types = ["t2.medium", "t3.medium"]
  }

  eks_managed_node_groups = {
    green = {
      min_size     = 2
      max_size     = 5
      desired_size = 2

      instance_types = ["t3.medium"]
    }
  }

  aws_auth_roles = [
    {
      rolearn  = "arn:aws:iam::466637063229:role/codebuild-role"
    }
  ]

  aws_auth_users = [
    {
      userarn  = "arn:aws:iam::466637063229:user/mishel"
      username = "mishel"
      groups   = ["system:masters"]
    }
  ]

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}