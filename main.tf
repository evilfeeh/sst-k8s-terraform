terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.67.0"
    }
  } 
  cloud { 
    organization = "sst-fiap-soat"
    workspaces { 
      name = "sst-k8s-terraform"
    } 
  } 
}

provider "aws" {
  region = local.region
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.self_service_totem.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.self_service_totem.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.self_service_totem.token
}

module "metrics_server" {
  source = "lablabs/eks-metrics-server/aws"

  enabled           = true
  argo_enabled      = false
  argo_helm_enabled = false

  helm_release_name = "metrics-server"
  namespace         = "kube-system"

  values = yamlencode({
    "podLabels" : {
      "app" : "test-metrics-server"
    }
  })

  helm_timeout = 240
  helm_wait    = true
}

data "aws_eks_cluster" "cluster" {
  name = aws_eks_cluster.self_service_totem.name
}

data "aws_eks_cluster_auth" "cluster" {
  name = aws_eks_cluster.self_service_totem.name
}

data "aws_availability_zones" "available" {}

data "aws_eks_cluster" "self_service_totem" {
  name = aws_eks_cluster.self_service_totem.name
}

data "aws_eks_cluster_auth" "self_service_totem" {
  name = aws_eks_cluster.self_service_totem.name
}

data "aws_iam_role" "existing_lambda_role" {
  name = "LabRole"
}

resource "aws_eks_cluster" "self_service_totem" {
  name     = local.name
  role_arn = local.aws_arn

  vpc_config {
    subnet_ids              = module.vpc.private_subnets
    endpoint_private_access = true
  }

  tags = local.tags
}

resource "aws_eks_node_group" "self_service_totem_node_group" {
  cluster_name    = aws_eks_cluster.self_service_totem.name
  node_group_name = "node-group"
  node_role_arn   = local.aws_arn
  subnet_ids      = module.vpc.private_subnets

  scaling_config {
    desired_size = 1
    max_size     = 10
    min_size     = 1
  }

  instance_types = ["t3.small"]
  capacity_type  = "SPOT"

  tags = local.tags
}

locals {
  region   = "us-east-1"
  name     = "self-service-totem"
  repository_name = "sst-k8s-terraform"
  organization = "sst-fiap-soat"
  azs      = ["us-east-1a", "us-east-1b"]
  vpc_cidr = "10.0.0.0/16"
  tags = {
    "kubernetes.io/cluster/${local.name}" = "shared"
  }
  role_arn = data.aws_iam_role.existing_lambda_role.arn
  aws_arn  = data.aws_iam_role.existing_lambda_role.arn
}