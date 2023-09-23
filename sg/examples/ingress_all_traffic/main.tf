locals {
  tags = {
    Environment = "hml"
  }
  sgname      = "sgteste"
  environment = "hml"
}

module "sg" {
  source      = "github.com/Emerson89/terraform-modules.git//sg?ref=main"
  sgname      = local.sgname
  environment = local.environment
  vpc_id      = "vpc-abcabcabc"

  rules_security_group = {

    ## Rule ingress all traffic cidr_block
    ingress_rule_1 = {
      from_port   = 0
      to_port     = 65535
      protocol    = "-1"
      type        = "ingress"
      cidr_blocks = ["10.11.10.0/16"]
    },

    ## Rule ingress all traffic source_security
    ingress_rule_2 = {
      from_port                = 0
      to_port                  = 65535
      protocol                 = "-1"
      type                     = "ingress"
      source_security_group_id = "sg-abcabcabc"
    }
  }

  tags = local.tags

}
