locals {
  ingress_cidr = {
    "ingress_rule_1" = {
      "from_port"   = "6379"
      "to_port"     = "6379"
      "protocol"    = "tcp"
      "cidr_blocks" = ["11.11.11.1/16"]
    }
  }
  ingress_source = {
    "ingress_rule_1" = {
      "from_port" = "6379"
      "to_port"   = "6379"
      "protocol"  = "tcp"
    },
  }
}