locals {
  combined_routes = merge(
    var.create_route_private ? { for k, v in var.routes_private : "private_${k}" => merge(v, { route_table_id = aws_route_table.private.id }) } : {},
    var.create_route_public ? { for k, v in var.routes_public : "public_${k}" => merge(v, { route_table_id = aws_route_table.public.id }) } : {},
    var.create_route_additional ? { for k, v in var.routes_add : "additional_${k}" => merge(v, { route_table_id = aws_route_table.additional.id }) } : {}
  )

}

resource "aws_vpc" "this" {
  cidr_block                       = var.cidr_block
  assign_generated_ipv6_cidr_block = var.assign_generated_ipv6_cidr_block
  instance_tenancy                 = var.instance_tenancy
  enable_dns_support               = var.enable_dns_support
  enable_dns_hostnames             = var.enable_dns_hostnames

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

resource "aws_iam_role_policy" "this" {
  count = var.create_aws_flow_log ? 1 : 0

  name_prefix = "vpc-flow-logs-policy-"
  role        = aws_iam_role.this[0].id
  policy      = data.aws_iam_policy_document.this[0].json
}

#### SUBNETS
data "aws_availability_zones" "azs" {}

resource "aws_subnet" "private" {
  count           = length(var.private_subnets)
  vpc_id          = aws_vpc.this.id
  cidr_block      = cidrsubnet(aws_vpc.this.cidr_block, var.newbits, var.private_subnets[count.index])
  ipv6_cidr_block = var.enable_ipv6 ? cidrsubnet(aws_vpc.this.ipv6_cidr_block, 8, var.private_subnet_ipv6_prefix[count.index]) : null
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
  count           = length(var.public_subnets)
  vpc_id          = aws_vpc.this.id
  cidr_block      = cidrsubnet(aws_vpc.this.cidr_block, var.newbits, var.public_subnets[count.index])
  ipv6_cidr_block = var.enable_ipv6 ? cidrsubnet(aws_vpc.this.ipv6_cidr_block, 8, var.public_subnet_ipv6_prefix[count.index]) : null
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

resource "aws_subnet" "additional" {
  count           = length(var.additional_subnets)
  vpc_id          = aws_vpc.this.id
  cidr_block      = cidrsubnet(aws_vpc.this.cidr_block, var.newbits, var.additional_subnets[count.index])
  ipv6_cidr_block = var.enable_ipv6 && var.create_additional_subnet_ipv6 ? cidrsubnet(aws_vpc.this.ipv6_cidr_block, 8, var.additional_subnet_ipv6_prefix[count.index]) : null
  availability_zone = element(data.aws_availability_zones.azs.names,
    count.index % length(data.aws_availability_zones.azs.names),
  )
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = merge(
    {
      "Name"     = format("additional-${var.environment}-%s", element(data.aws_availability_zones.azs.names, count.index)),
      "Type"     = "subnet"
      "Platform" = "network"
      "Network"  = "additional"
    },
    var.additional_subnets_tags,
  )
}

## Routes public

resource "aws_route" "public_internet_gateway" {
  count = var.create_igw ? 1 : 0

  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this[0].id

  timeouts {
    create = "5m"
  }
}

resource "aws_route" "public_internet_gateway_ipv6" {
  count = var.create_igw && var.enable_ipv6 ? 1 : 0

  route_table_id              = aws_route_table.public.id
  destination_ipv6_cidr_block = "::/0"
  gateway_id                  = aws_internet_gateway.this[0].id
}

## Routes private

resource "aws_route" "private_nat" {
  count = var.create_nat ? 1 : 0

  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this[0].id
}

resource "aws_route" "private_nat_ipv6" {
  count = var.create_nat && var.enable_ipv6 ? 1 : 0

  route_table_id              = aws_route_table.private.id
  destination_ipv6_cidr_block = "64:ff9b::/96"
  nat_gateway_id              = aws_nat_gateway.this[0].id
}

## Routes additional
resource "aws_route" "dynamic" {
  for_each = local.combined_routes

  route_table_id = each.value.route_table_id

  destination_ipv6_cidr_block = lookup(each.value, "destination_ipv6_cidr_block", null)
  destination_cidr_block      = lookup(each.value, "destination_cidr_block", null)

  transit_gateway_id        = lookup(each.value, "transit_gateway_id", null)
  vpc_endpoint_id           = lookup(each.value, "vpc_endpoint_id", null)
  vpc_peering_connection_id = lookup(each.value, "vpc_peering_connection_id", null)
}

resource "aws_route" "additional_nat" {
  count = var.create_nat && var.route_nat_additional ? 1 : 0

  route_table_id         = aws_route_table.additional.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this[0].id
}

resource "aws_route" "additional_nat_ipv6" {
  count = var.create_nat && var.enable_ipv6 && var.route_nat_additional ? 1 : 0

  route_table_id              = aws_route_table.additional.id
  destination_ipv6_cidr_block = "64:ff9b::/96"
  nat_gateway_id              = aws_nat_gateway.this[0].id
}

resource "aws_route" "additional_internet_gateway" {
  count = var.create_igw && var.route_igw_additional ? 1 : 0

  route_table_id         = aws_route_table.additional.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this[0].id

  timeouts {
    create = "5m"
  }
}

resource "aws_route" "additional_internet_gateway_ipv6" {
  count = var.create_igw && var.enable_ipv6 && var.route_igw_additional ? 1 : 0

  route_table_id              = aws_route_table.additional.id
  destination_ipv6_cidr_block = "::/0"
  gateway_id                  = aws_internet_gateway.this[0].id
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

resource "aws_route_table" "additional" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    {
      "Name"     = format("add-%s-%s", var.rtname, var.environment)
      "Platform" = "network"
      "Type"     = "route-table"
      "Network"  = "Addicional"
    },
    var.tags,

  )
}

resource "aws_route_table_association" "private" {
  count          = max(length(var.private_subnets), length(var.private_subnet_ipv6_prefix))
  subnet_id      = element(aws_subnet.private[*].id, count.index)
  route_table_id = element(aws_route_table.private[*].id, count.index)
}

resource "aws_route_table_association" "public" {
  count          = max(length(var.public_subnets), length(var.public_subnet_ipv6_prefix))
  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = element(aws_route_table.public[*].id, count.index)
}

resource "aws_route_table_association" "additional" {
  count          = max(length(var.additional_subnets), length(var.additional_subnet_ipv6_prefix))
  subnet_id      = element(aws_subnet.additional[*].id, count.index)
  route_table_id = element(aws_route_table.additional[*].id, count.index)
}