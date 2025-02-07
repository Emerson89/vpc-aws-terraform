variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "cidr_block" {
  description = "The IPv4 CIDR block for the VPC."
  type        = string
  default     = ""
}

variable "create_aws_flow_log" {
  description = "Create vpc flow log"
  type        = bool
  default     = false
}

variable "create_nat" {
  description = "Create nat-gateway"
  type        = bool
  default     = true
}

variable "create_igw" {
  description = "Create igw-gateway"
  type        = bool
  default     = true
}
#variables igw

variable "igwname" {
  description = "Name to be used the resources as identifier"
  type        = string
  default     = "igw"
}

#variables nat
variable "natname" {
  description = "Name to be used the resources as identifier"
  type        = string
  default     = "nat"
}

## routes
variable "rtname" {
  description = "Name to be used the resources as identifier"
  type        = string
  default     = "rt"
}

variable "public_subnets_tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(any)
  default     = {}
}

variable "private_subnets_tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(any)
  default     = {}
}

variable "additional_subnets_tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(any)
  default     = {}
}

variable "traffic_type" {
  description = "The type of traffic to capture. Valid values: ACCEPT,REJECT, ALL"
  type        = string
  default     = "ALL"
}

variable "instance_tenancy" {
  description = "A tenancy option for instances launched into the VPC. Default is default"
  type        = string
  default     = "default"
}

variable "environment" {
  description = "Env resources"
  type        = string
  default     = "hmg"
}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "additional_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(any)
  default     = {}
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

variable "enable_ipv6" {
  description = "Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length for the VPC. You cannot specify the range of IP addresses, or the size of the CIDR block"
  type        = bool
  default     = false
}

variable "public_subnet_ipv6_prefix" {
  description = "Assigns IPv6 public subnet id based on the Amazon provided /56 prefix base 10 integer (0-256). Must be of equal length to the corresponding IPv4 subnet list"
  type        = list(string)
  default     = []
}

variable "private_subnet_ipv6_prefix" {
  description = "Assigns IPv6 public subnet id based on the Amazon provided /56 prefix base 10 integer (0-256). Must be of equal length to the corresponding IPv4 subnet list"
  type        = list(string)
  default     = []
}

variable "additional_subnet_ipv6_prefix" {
  description = "Assigns IPv6 public subnet id based on the Amazon provided /56 prefix base 10 integer (0-256). Must be of equal length to the corresponding IPv4 subnet list"
  type        = list(string)
  default     = []
}

variable "assign_generated_ipv6_cidr_block" {
  description = " Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length for the VPC. You cannot specify the range of IP addresses, or the size of the CIDR block. Default is false"
  type        = bool
  default     = false
}

variable "create_route_additional" {
  description = "Boolean to create add routes"
  type        = bool
  default     = false
}

variable "create_route_private" {
  description = "Boolean to create private routes"
  type        = bool
  default     = false
}

variable "create_route_public" {
  description = "Boolean to create public routes"
  type        = bool
  default     = false
}

variable "routes_private" {
  description = "Map of private routes"
  type        = map(any)
  default     = {}
}

variable "routes_public" {
  description = "Map of public routes"
  type        = map(any)
  default     = {}
}

variable "routes_add" {
  description = "Map of additional routes"
  type        = map(any)
  default     = {}
}

variable "newbits" {
  description = "Is the number of additional bits with which to extend the prefix. For example, if given a prefix ending in /16 and a newbits value of 4, the resulting subnet address will have length /20"
  type        = number
  default     = 4
}

variable "route_igw_additional" {
  description = "Routes igw subnets additional"
  type        = bool
  default     = false
}

variable "route_nat_additional" {
  description = "Routes nat subnets additional"
  type        = bool
  default     = false
}

variable "create_additional_subnet_ipv6" {
  description = "Create subnet additional ipv6"
  type        = bool
  default     = false
}

variable "create_vpc" {
  description = "Create vpc"
  type        = bool
  default     = true
}

variable "vpc_id" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}
