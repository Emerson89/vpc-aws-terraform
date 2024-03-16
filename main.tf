locals {

  route_table_routes_private = merge(
    var.create_nat ? {
      "nat" = {
        "cidr_block"     = "0.0.0.0/0"
        "nat_gateway_id" = "${aws_nat_gateway.this[0].id}"
      }
    } : {},
  var.route_table_routes_private)

  route_table_routes_public = merge(
    var.create_igw ? {
      "igw" = {
        "cidr_block" = "0.0.0.0/0"
        "gateway_id" = "${aws_internet_gateway.this[0].id}"
      }
    } : {},
  var.route_table_routes_public)
}

resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  instance_tenancy     = var.instance_tenancy
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = merge(
    {
      "Name"     = format("%s-%s", var.name, var.environment)
      "Platform" = "network"
      "Type"     = "vpc"
    },
    var.tags,
  )
}

## FLOW_LOGS

resource "aws_flow_log" "this" {
  count = var.create_aws_flow_log ? 1 : 0

  iam_role_arn    = aws_iam_role.this[0].arn
  log_destination = aws_cloudwatch_log_group.this[0].arn
  traffic_type    = var.traffic_type
  vpc_id          = aws_vpc.this.id
}

resource "aws_cloudwatch_log_group" "this" {
  count = var.create_aws_flow_log ? 1 : 0

  name_prefix = "vpc-flow-logs-"
}

data "aws_iam_policy_document" "assume_role" {
  count = var.create_aws_flow_log ? 1 : 0

  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "this" {
  count = var.create_aws_flow_log ? 1 : 0

  name_prefix        = "vpc-flow-log-role-"
  assume_role_policy = data.aws_iam_policy_document.assume_role[0].json
}

data "aws_iam_policy_document" "this" {
  count = var.create_aws_flow_log ? 1 : 0

  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "example" {
  count = var.create_aws_flow_log ? 1 : 0

  name_prefix = "vpc-flow-logs-policy-"
  role        = aws_iam_role.this[0].id
  policy      = data.aws_iam_policy_document.this[0].json
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
      "Name"     = format("private-${var.environment}-%s", element(data.aws_availability_zones.azs.names, count.index)),
      "Type"     = "subnet"
      "Platform" = "network"
      "Network"  = "Private"
    },
    var.private_subnets_tags,
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
      "Name"     = format("public-${var.environment}-%s", element(data.aws_availability_zones.azs.names, count.index)),
      "Type"     = "subnet"
      "Platform" = "network"
      "Network"  = "Public"
    },
    var.public_subnets_tags,
  )
}

## IGW
resource "aws_internet_gateway" "this" {
  count = var.create_igw ? 1 : 0

  vpc_id = aws_vpc.this.id

  tags = merge(
    {
      "Name"     = format("%s-%s", var.igwname, var.environment)
      "Platform" = "network"
      "Type"     = "IGW"
    },
    var.tags,

  )
}

### NAT

resource "aws_eip" "this" {
  count = var.create_nat ? 1 : 0

  domain = "vpc"

  tags = merge(
    {
      "Name"     = format("%s-%s-elastic-ip", var.natname, var.environment)
      "Platform" = "network"
      "Type"     = "nat"
    },
    var.tags,
  )

}

resource "aws_nat_gateway" "this" {
  count = var.create_nat ? 1 : 0

  allocation_id     = aws_eip.this[0].id
  subnet_id         = aws_subnet.public[0].id
  connectivity_type = "public"

  tags = merge(
    {
      "Name"     = format("%s-%s", var.natname, var.environment)
      "Platform" = "network"
      "Type"     = "nat"
    },
    var.tags,
  )

  depends_on = [aws_internet_gateway.this[0]]
}

## ROUTES

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  dynamic "route" {
    for_each = local.route_table_routes_public
    content {
      cidr_block = lookup(route.value, "cidr_block", null)

      egress_only_gateway_id    = lookup(route.value, "egress_only_gateway_id", null)
      gateway_id                = lookup(route.value, "gateway_id", null)
      nat_gateway_id            = lookup(route.value, "nat_gateway_id", null)
      network_interface_id      = lookup(route.value, "network_interface_id", null)
      transit_gateway_id        = lookup(route.value, "transit_gateway_id", null)
      vpc_endpoint_id           = lookup(route.value, "vpc_endpoint_id", null)
      vpc_peering_connection_id = lookup(route.value, "vpc_peering_connection_id", null)
    }
  }
  tags = merge(
    {
      "Name"     = format("public-%s-%s", var.rtname, var.environment)
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
    for_each = local.route_table_routes_private
    content {
      cidr_block = lookup(route.value, "cidr_block", null)

      egress_only_gateway_id    = lookup(route.value, "egress_only_gateway_id", null)
      gateway_id                = lookup(route.value, "gateway_id", null)
      nat_gateway_id            = lookup(route.value, "nat_gateway_id", null)
      network_interface_id      = lookup(route.value, "network_interface_id", null)
      transit_gateway_id        = lookup(route.value, "transit_gateway_id", null)
      vpc_endpoint_id           = lookup(route.value, "vpc_endpoint_id", null)
      vpc_peering_connection_id = lookup(route.value, "vpc_peering_connection_id", null)
    }
  }

  tags = merge(
    {
      "Name"     = format("private-%s-%s", var.rtname, var.environment)
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
