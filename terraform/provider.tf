locals {
  region          = "us-east-1"
  name            = "self-service-totem"
  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  vpc_cidr        = "10.123.0.0/16"
  public_subnets  = ["10.123.0.0/24", "10.123.1.0/24", "10.123.2.0/24"]
  private_subnets = ["10.123.3.0/24", "10.123.4.0/24", "10.123.5.0/24"]
  intra_subnets   = ["10.123.6.0/24", "10.123.7.0/24", "10.123.8.0/24"]
  tags = {
    "kubernetes.io/cluster/${local.name}" = "shared"
  }
}

provider "aws" {
  region     = "us-east-1"
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
  token      = var.session_token
}