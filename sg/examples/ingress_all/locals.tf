locals {
    ingress = {
    "ingress_rule_1" = {
      "from_port"   = "0"
      "to_port"     = "65535" ##all internal traffic 
      "protocol"    = "-1"
      "cidr_blocks" = ["10.11.10.0/16"]
    },
    "ingress_rule_2" = {
      "from_port"   = "0"
      "to_port"     = "65535" ##all internal traffic 
      "protocol"    = "-1"
      "cidr_blocks" = ["10.11.10.0/16"]
    },
  }
}