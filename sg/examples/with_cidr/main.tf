module "sg" {
  source      = "github.com/Emerson89/terraform-modules.git//sg?ref=main"
  sgname      = var.sgname
  environment = var.environment
  description = var.description
  vpc_id      = "vpc-id"

  tags = var.tags

  ingress_with_cidr_blocks = local.ingress
}
