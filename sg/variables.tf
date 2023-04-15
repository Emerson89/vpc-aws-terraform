##variables security-group
variable "sgname" {
  description = "Name to be used the resources as identifier"
  type        = string
}

variable "source_security_group_id" {
  description = "Source security-group id"
  type        = string
  default     = ""
}

variable "vpc_id" {
  description = "VPC id"
  type        = string
}

variable "description" {
  description = "Description of security group"
  type        = string
  default     = "Security Group managed by Terraform"
}

variable "environment" {
  description = "Env tags"
  type        = string
  default     = null
}

variable "ingress_with_cidr_blocks" {
  description = "Ingress rules security group"
  type        = map(any)
  default     = {}
}

variable "ingress_with_source_security_group" {
  description = "Ingress rules security group"
  type        = map(any)
  default     = {}
}

variable "egress" {
  type = map(any)
  default = {
    "engress_rule" = {
      "from_port"   = "0"
      "to_port"     = "0"
      "protocol"    = "-1"
      "cidr_blocks" = ["0.0.0.0/0"]
    }
  }
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(any)
  default     = {}
}
