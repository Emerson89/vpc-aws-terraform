module "sg" {
  source                   = "github.com/Emerson89/terraform-modules.git//sg?ref=main"
  sgname                   = var.sgname
  environment              = var.environment
  description              = var.description
  vpc_id                   = "vpc-id"
  source_security_group_id = "sg-id-source"

  tags = var.tags

  ingress_with_source_security_group = local.ingress

}
