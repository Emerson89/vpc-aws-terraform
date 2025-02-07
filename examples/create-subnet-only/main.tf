module "vpc" {
  source = "github.com/Emerson89/vpc-aws-terraform.git?ref=v2.1.0"

  create_vpc = false
  create_nat = false
  create_igw = false

  vpc_id = "vpc-abcabcdbacb"

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

  private_subnets = ["172.31.96.0/20", "172.31.112.0/20", "172.31.128.0/20"]
  public_subnets  = ["172.31.144.0/20", "172.31.160.0/20", "172.31.176.0/20"]

  map_public_ip_on_launch = true

  rtname = "my-rt"
}
