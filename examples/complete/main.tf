module "vpc" {
  source = "github.com/Emerson89/vpc-aws-terraform.git?ref=v2.0.0"

  name                 = "my-vpc"
  cidr_block           = "10.0.0.0/16"
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

  ## if a prefix ending in /16 and a newbit value of 4 is provided, the resulting subnet address will have length /20 (default is 4) that enables 4094 hosts and 16 subnets
  newbits = 4
  ## Sequence of subnets by zones starting with 0 = us-east-1a, 1 = us-east-1b..., respecting the sequence to not underlay the nets
  private_subnets      = [0, 1, 2]
  public_subnets       = [3, 4, 5]
  additional_subnets   = [6, 7, 8]
  route_nat_additional = true

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
