resource "aws_vpc" "this" {

  cidr_block           = var.cidr_block
  instance_tenancy     = var.instance_tenancy
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = merge(
    {
      "Name"     = format("%s", var.name)
      "Platform" = "network"
      "Type"     = "vpc"
    },
    var.tags,
  )
}

## FLOW_LOGS

resource "aws_flow_log" "this" {
  iam_role_arn    = var.iam_role_arn
  log_destination = var.log_destination_arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.this.id

}

#### SUBNETS
data "aws_availability_zones" "azs" {}

resource "aws_subnet" "private" {
  count      = length(var.private_subnets)
  vpc_id     = aws_vpc.this.id
  cidr_block = element(var.private_subnets, count.index)
  availability_zone = element(data.aws_availability_zones.azs.names,
    count.index % length(data.aws_availability_zones.azs.names),
  )

  tags = merge(
    {
      "Name"     = format("private-%s", element(data.aws_availability_zones.azs.names, count.index)),
      "Type"     = "subnet"
      "Platform" = "network"
      "Network"  = "Private"
    },
    var.tags,
  )
}


resource "aws_subnet" "public" {
  count      = length(var.public_subnets)
  vpc_id     = aws_vpc.this.id
  cidr_block = element(var.public_subnets, count.index)
  availability_zone = element(data.aws_availability_zones.azs.names,
    count.index % length(data.aws_availability_zones.azs.names),
  )
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = merge(
    {
      "Name"     = format("public-%s", element(data.aws_availability_zones.azs.names, count.index)),
      "Type"     = "subnet"
      "Platform" = "network"
      "Network"  = "Public"
    },
    var.tags,
  )
}

## IGW
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    {
      "Name"     = format("%s", var.igwname)
      "Platform" = "network"
      "Type"     = "IGW"
    },
    var.tags,

  )
}

### NAT

resource "aws_eip" "this" {
  vpc = true

  tags = merge(
    {
      "Name"     = format("%s-elastic-ip", var.natname)
      "Platform" = "network"
      "Type"     = "nat"
    },
    var.tags,
  )

}

resource "aws_nat_gateway" "this" {
  allocation_id     = aws_eip.this.id
  subnet_id         = aws_subnet.public[0].id
  connectivity_type = "public"

  tags = merge(
    {
      "Name"     = format("%s", var.natname)
      "Platform" = "network"
      "Type"     = "nat"
    },
    var.tags,
  )

  depends_on = [aws_internet_gateway.this]
}

## ROUTES

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  dynamic "route" {
    for_each = var.route_table_routes_public
    content {
      cidr_block = route.value.cidr_block

      egress_only_gateway_id    = lookup(route.value, "egress_only_gateway_id", null)
      gateway_id                = lookup(route.value, "gateway_id", null)
      instance_id               = lookup(route.value, "instance_id", null)
      nat_gateway_id            = lookup(route.value, "nat_gateway_id", null)
      network_interface_id      = lookup(route.value, "network_interface_id", null)
      transit_gateway_id        = lookup(route.value, "transit_gateway_id", null)
      vpc_endpoint_id           = lookup(route.value, "vpc_endpoint_id", null)
      vpc_peering_connection_id = lookup(route.value, "vpc_peering_connection_id", null)
    }
  }
  tags = merge(
    {
      "Name"     = format("public-%s", var.rtname)
      "Platform" = "network"
      "Type"     = "route-table"
      "Network"  = "Public"
    },
    var.tags,

  )
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  dynamic "route" {
    for_each = var.route_table_routes_private
    content {
      cidr_block = route.value.cidr_block

      egress_only_gateway_id    = lookup(route.value, "egress_only_gateway_id", null)
      gateway_id                = lookup(route.value, "gateway_id", null)
      instance_id               = lookup(route.value, "instance_id", null)
      nat_gateway_id            = lookup(route.value, "nat_gateway_id", null)
      network_interface_id      = lookup(route.value, "network_interface_id", null)
      transit_gateway_id        = lookup(route.value, "transit_gateway_id", null)
      vpc_endpoint_id           = lookup(route.value, "vpc_endpoint_id", null)
      vpc_peering_connection_id = lookup(route.value, "vpc_peering_connection_id", null)
    }
  }

  tags = merge(
    {
      "Name"     = format("private-%s", var.rtname)
      "Platform" = "network"
      "Type"     = "route-table"
      "Network"  = "Private"
    },
    var.tags,

  )
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets)
  subnet_id      = element(aws_subnet.private[*].id, count.index)
  route_table_id = element(aws_route_table.private[*].id, count.index)
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = element(aws_route_table.public[*].id, count.index)
}
