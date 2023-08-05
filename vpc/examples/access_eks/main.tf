locals {
  environment = "develop"
  tags = {
    Environment = "develop"
  }
  private_subnets_tags = {
    "kubernetes.io/cluster/develop"   = "shared",
    "kubernetes.io/role/internal-elb" = 1
  }
  public_subnets_tags = {
    "kubernetes.io/cluster/develop" = "shared",
    "kubernetes.io/role/elb"        = 1
  }
}

module "vpc" {
  source = "github.com/Emerson89/terraform-modules.git//vpc?ref=main"

  name                 = var.name
  cidr_block           = var.cidr_block
  instance_tenancy     = var.instance_tenancy
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags        = local.tags
  environment = local.environment

  private_subnets_tags = local.private_subnets_tags
  public_subnets_tags  = local.public_subnets_tags

  private_subnets         = var.private_subnets
  public_subnets          = var.public_subnets
  map_public_ip_on_launch = var.map_public_ip_on_launch

  igwname = var.igwname
  natname = var.natname
  rtname  = var.rtname

  route_table_routes_private = {
    "nat" = {
      "nat_gateway_id" = "${module.vpc.nat}"
    }
  }
  route_table_routes_public = {
    "igw" = {
      "gateway_id" = "${module.vpc.igw}"
    }
  }

}
