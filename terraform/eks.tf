resource "aws_iam_role" "eks_cluster" {
  name = "eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster.name
  policy_arn  = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}


resource "aws_iam_role" "eks_node_group" {
  name = "eks-node-group-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_node_group_policy" {
  role       = aws_iam_role.eks_node_group.name
  policy_arn  = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_node_group_cni_policy" {
  role       = aws_iam_role.eks_node_group.name
  policy_arn  = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_eks_cluster" "self-service-totem" {
  name     = local.name
  role_arn  = "arn:aws:iam::210567676973:role/LabRole"
  vpc_config {
    subnet_ids = module.vpc.private_subnets
  }

  tags = local.tags
}

resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = aws_eks_cluster.self-service-totem.name
  node_group_name = "node-group"
  node_role_arn   = aws_iam_role.eks_node_group.arn
  subnet_ids       = module.vpc.private_subnets
  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  instance_types = ["t3.small"]
  capacity_type  = "SPOT"

  tags = local.tags
}

resource "aws_eks_addon" "coredns_addon" {
  cluster_name = aws_eks_cluster.self-service-totem.name
  addon_name   = "coredns"
}

resource "aws_eks_addon" "vpn_addon" {
  cluster_name = aws_eks_cluster.self-service-totem.name
  addon_name   = "vpc-cni"
}

resource "aws_eks_addon" "kubeproxy_addon" {
  cluster_name = aws_eks_cluster.self-service-totem.name
  addon_name   = "kube-proxy"
}