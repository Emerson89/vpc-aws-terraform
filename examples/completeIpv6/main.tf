module "vpc" {
  source = "github.com/Emerson89/vpc-aws-terraform.git?ref=v2.0.0"

  name                 = "my-vpc"
  cidr_block           = "10.30.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  create_aws_flow_log = true

  tags = {
    Environment = "hml"
  }
  environment = "hml"

  ## if a prefix ending in /16 and a newbit value of 4 is provided, the resulting subnet address will have length /20 (default is 4) that enables 4094 hosts and 16 subnets
  newbits = 4
  ## Sequence of subnets by zones starting with 0 = us-east-1a, 1 = us-east-1b..., respecting the sequence to not underlay the nets
  private_subnets      = [0, 1, 2]
  public_subnets       = [3, 4, 5]
  additional_subnets   = [6, 7, 8]
  route_nat_additional = true

  enable_ipv6                      = true
  assign_generated_ipv6_cidr_block = true
  public_subnet_ipv6_prefix        = [0, 1, 2]
  private_subnet_ipv6_prefix       = [3, 4, 5]
  create_additional_subnet_ipv6    = true
  additional_subnet_ipv6_prefix    = [6, 7, 8]

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

  create_nat = true
  create_igw = true

  igwname = "my-igw"
  natname = "my-nat"
  rtname  = "my-rt"
}
