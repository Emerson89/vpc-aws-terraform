locals {
  environment = "develop"
  tags = {
    Environment = "develop"
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

  private_subnets         = var.private_subnets
  public_subnets          = var.public_subnets
  map_public_ip_on_launch = var.map_public_ip_on_launch

  igwname = var.igwname
  natname = var.natname
  rtname  = var.rtname

  route_table_routes_private = {
    ## add block to create route in subnet-public
    "peer" = {
      "cidr_block"                = "10.10.0.0/16"
      "vpc_peering_connection_id" = "pcx-xxxxxxxxxxxxx"
    }
  }
  route_table_routes_public = {
    ## add block to create route in subnet-private
    "peer" = {
      "cidr_block"                = "10.10.0.0/16"
      "vpc_peering_connection_id" = "pxc-xxxxxxxxxxxxxxx"
    }

  }
}