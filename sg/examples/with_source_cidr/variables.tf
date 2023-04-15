variable "ingress_cidr" {
  description = "Ingress rules security group"
  type        = map(any)
  default     = {
    ingress_1 = {
     "ingress_rule_1" = {
      "from_port"   = "6379"
      "to_port"     = "6379"
      "protocol"    = "tcp"
      "cidr_blocks" = ["11.11.11.1/16"]
    }
  }
  }
} 

variable "ingress_source" {
  description = "Ingress rules security group"
  type        = map(any)
  default     = {
    ingress_1 = {
      "ingress_rule_1" = {
        "from_port" = "443"
        "to_port"   = "443"
        "protocol"  = "tcp"
      },
    }
  }
}

variable "description" {
  description = "Description of security group"
  type        = string
  default     = "Security Group managed by Terraform"
}

variable "environment" {
  description = "Env tags"
  type        = string
  default     = "hml"
}

variable "sgname" {
  description = "Name to be used the resources as identifier"
  type        = string
  default = "sg-teste"
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(any)
  default     = {
    Environment = "hml"
  }
}
