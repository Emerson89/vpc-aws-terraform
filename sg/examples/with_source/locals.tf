locals {
  ingress = {
    "ingress_rule_1" = {
      "from_port" = "5432"
      "to_port"   = "5432" ##all internal traffic 
      "protocol"  = "tcp"
    },
    "ingress_rule_2" = {
      "from_port" = "443"
      "to_port"   = "443" ##all internal traffic 
      "protocol"  = "tcp"
    },
  }
}