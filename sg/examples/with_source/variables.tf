variable "ingress" {
  description = "Ingress rules security group"
  type        = map(any)
  default     = {
     "ingress_rule_1" = {
      "from_port" = "443"
      "to_port"   = "443"
      "protocol"  = "tcp"
    },
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
