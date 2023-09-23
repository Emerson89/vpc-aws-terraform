module "vpc" {
  source = "github.com/Emerson89/vpc-aws-terraform.git?ref=v1.0.0"

  name                 = "my-vpc"
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Environment = "hml"
  }
  environment = "hml"

  private_subnets_tags = {
    "kubernetes.io/cluster/develop"   = "shared",
    "kubernetes.io/role/internal-elb" = 1
  }
  public_subnets_tags = {
    "kubernetes.io/cluster/develop" = "shared",
    "kubernetes.io/role/elb"        = 1
  }

  private_subnets         = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  public_subnets          = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  map_public_ip_on_launch = true

  igwname = "my-igw"
  natname = "my-nat"
  rtname  = "my-rt"

}