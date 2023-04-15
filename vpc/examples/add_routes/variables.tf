## Variables VPC

variable "instance_tenancy" {
  description = "A tenancy option for instances launched into the VPC. Default is default"
  type        = string
  default     = "default"
}

variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = "my-vpc"
}

variable "cidr_block" {
  description = " The IPv4 CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "environment" {
  description = "Env tags"
  type        = string
  default     = "hml"
}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default = {
    Environment = "hml"
  }
}

variable "map_public_ip_on_launch" {
  description = "Should be false if you do not want to auto-assign public IP on launch"
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "Enable dns hostnames"
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "Enable dns support"
  type        = bool
  default     = true
}

## Variables igw
variable "igwname" {
  description = "Name to be used the resources as identifier"
  type        = string
  default     = "igw-teste"
}

## Variables nat
variable "natname" {
  description = "Name to be used the resources as identifier"
  type        = string
  default     = "nat-teste"
}

## Variables routes
variable "rtname" {
  description = "Name to be used the resources as identifier"
  type        = string
  default     = "rt-teste"
}
