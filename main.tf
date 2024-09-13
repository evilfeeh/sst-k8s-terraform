provider "aws" {
  region = "us-east-1"
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

data "aws_availability_zones" "available" {}

resource "aws_security_group" "worker_group_mgmt_one" {
  name_prefix = "worker_group_mgmt_one"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "10.0.0.0/8",
    ]
  }
}


resource "aws_security_group" "all_worker_mgmt" {
  name_prefix = "all_worker_management"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "10.0.0.0/8",
      "172.16.0.0/12",
      "192.168.0.0/16",
    ]
  }
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "20.24.0"
  cluster_name    = local.name
  cluster_version = "1.17"

  cluster_endpoint_private_access = true
  iam_role_arn                    = local.aws_arn
  vpc_id                          = module.vpc.vpc_id
  subnet_ids                      = module.vpc.private_subnets

  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
  }

  eks_managed_node_groups = [
    {
      iam_role_arn         = local.aws_arn
      ami_type             = "AL2023_x86_64_STANDARD"
      instance_type        = "t3.small"
      asg_desired_capacity = 1
      min_size             = 2
      max_size             = 10
      desired_size         = 2
    },
  ]
}

locals {
  region   = "us-east-1"
  name     = "self-service-totem"
  azs      = ["us-east-1a", "us-east-1b", "us-east-1c"]
  vpc_cidr = "10.123.0.0/16"
  tags = {
    "kubernetes.io/cluster/${local.name}" = "shared"
  }
  role_arn = "LabRole"
  aws_arn  = "arn:aws:iam::210567676973:role/LabRole"
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}
