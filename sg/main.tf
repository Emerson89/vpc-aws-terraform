### SEGURITY_GROUP

resource "aws_security_group" "this" {
  name        = format("%s-%s-sg", var.sgname, var.environment)
  description = var.description
  vpc_id      = var.vpc_id

  tags = merge(
    {
      "Name"     = format("%s-%s", var.sgname, var.environment)
      "Platform" = "network"
      "Type"     = "segurity-group"
    },
    var.tags,
  )
}

resource "aws_security_group_rule" "with_source_security_group" {
  type                     = "ingress"
  for_each                 = var.ingress_with_source_security_group
  from_port                = each.value.from_port
  to_port                  = each.value.to_port
  protocol                 = each.value.protocol
  security_group_id        = aws_security_group.this.id
  source_security_group_id = var.source_security_group_id

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "ingress_rule" {
  type              = "ingress"
  for_each          = var.ingress_with_cidr_blocks
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks       = each.value.cidr_blocks
  security_group_id = aws_security_group.this.id

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "egress_rule" {
  type              = "egress"
  for_each          = var.egress
  from_port         = each.value["from_port"]
  to_port           = each.value["to_port"]
  protocol          = each.value["protocol"]
  cidr_blocks       = each.value["cidr_blocks"]
  security_group_id = aws_security_group.this.id
}