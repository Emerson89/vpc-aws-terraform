module "sg" {
 source = "github.com/Emerson89/modules-terraform.git//sg?ref=main"
 sgname      = var.sgname
 environment = var.environment
 description = var.description
 vpc_id      = "vpc-id"
 source_security_group_id = "sg-source-id"

 ingress_with_source_security_group = local.ingress_source
 ingress_with_cidr_blocks           = local.ingress_cidr

 tags = var.tags

}
