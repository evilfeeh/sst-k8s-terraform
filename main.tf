provider "aws" {
  region = "us-east-1"
}

data "aws_eks_cluster" "cluster" {
  name = aws_eks_cluster.self_service_totem.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = aws_eks_cluster.self_service_totem.cluster_id
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

resource "aws_eks_cluster" "self_service_totem" {
  name     = local.name
  role_arn = local.aws_arn  # Use LabRole here

  vpc_config {
    subnet_ids = module.vpc.private_subnets
    endpoint_private_access = true  # Private access to the API endpoint
  }

  tags = local.tags
}

resource "aws_eks_node_group" "self_service_totem_node_group" {
  cluster_name    = aws_eks_cluster.self_service_totem.name
  node_group_name = "node-group"
  node_role_arn   = local.aws_arn  # Use LabRole for nodes
  subnet_ids      = module.vpc.private_subnets

  scaling_config {
    desired_size = 2
    max_size     = 10
    min_size     = 2
  }

  instance_types = ["t3.small"]
  capacity_type  = "SPOT"

  tags = local.tags
}

data "aws_eks_cluster" "self_service_totem" {
  name = aws_eks_cluster.self_service_totem.name
}

data "aws_eks_cluster_auth" "self_service_totem" {
  name = aws_eks_cluster.self_service_totem.name
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
  host                   = data.aws_eks_cluster.self_service_totem.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.self_service_totem.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.self_service_totem.token
}