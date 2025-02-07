module "vpc" {
  source = "github.com/Emerson89/vpc-aws-terraform.git?ref=v2.1.0"

  name                 = "my-vpc"
  cidr_block           = "172.31.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  create_aws_flow_log  = true

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

  private_subnets = ["172.31.0.0/20", "172.31.16.0/20", "172.31.32.0/20"]
  public_subnets  = ["172.31.48.0/20", "172.31.64.0/20", "172.31.80.0/20"]
  #additional_subnets   = ["172.31.144.0/20", "172.31.160.0/20", "172.31.176.0/20"]
  #route_nat_additional = true

  map_public_ip_on_launch = true

  create_nat = true
  create_igw = true

  igwname = "my-igw"
  natname = "my-nat"
  rtname  = "my-rt"

  create_route_private = false
  routes_private = {
    private_route1 = {
      destination_cidr_block    = "172.31.0.0/16"
      vpc_peering_connection_id = "pcx-xxxxxxxxxxx"
    }
  }

  create_route_public = false
  routes_public = {
    public_route1 = {
      destination_cidr_block    = "172.31.0.0/16"
      vpc_peering_connection_id = "pcx-xxxxxxxxxxx"
    }
  }

  create_route_additional = false
  routes_add = {
    add_route1 = {
      destination_cidr_block    = "172.31.0.0/16"
      vpc_peering_connection_id = "pcx-xxxxxxxxxxx"
    }
  }
}
