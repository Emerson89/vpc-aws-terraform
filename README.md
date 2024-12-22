## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.9 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.9 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.9 |

## Usage

```hcl
module "vpc" {
  source = "github.com/Emerson89/vpc-aws-terraform.git?ref=v2.0.0"

  name                 = "my-vpc"
  cidr_block           = "10.30.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  create_aws_flow_log  = true

  tags = {
    Environment = "hml"
  }
  environment = "hml"

  ## if a prefix ending in /16 and a newbit value of 4 is provided, the resulting subnet address will have length /20 (default is 4) that enables 4094 hosts and 16 subnets
  newbits = 4
  ## Sequence of subnets by zones starting with 0 = us-east-1a, 1 = us-east-1b..., respecting the sequence to not underlay the nets
  private_subnets      = [0, 1, 2]
  public_subnets       = [3, 4, 5]
  additional_subnets   = [6, 7, 8]
  route_nat_additional = true

  enable_ipv6                      = true
  assign_generated_ipv6_cidr_block = true
  public_subnet_ipv6_prefix        = [0, 1, 2]
  private_subnet_ipv6_prefix       = [3, 4, 5]
  additional_subnet_ipv6_prefix    = [6, 7, 8]

  private_subnets_tags = {
    "kubernetes.io/cluster/develop"   = "shared",
    "kubernetes.io/role/internal-elb" = 1
  }
  
  public_subnets_tags  = {
    "kubernetes.io/cluster/develop" = "shared",
    "kubernetes.io/role/elb"        = 1
  }

  create_route_private = true
  routes_private = {
    private_route1 = {
      destination_cidr_block    = "172.31.0.0/16"
      vpc_peering_connection_id = "pcx-xxxxxxxxxxx"
    }
  }

  create_route_public = true
  routes_public = {
    public_route1 = {
      destination_cidr_block    = "172.31.0.0/16"
      vpc_peering_connection_id = "pcx-xxxxxxxxxxx"
    }
  }

  create_route_additional = true
  routes_add = {
    add_route1 = {
      destination_cidr_block    = "172.31.0.0/16"
      vpc_peering_connection_id = "pcx-xxxxxxxxxxx"
    }
  }

  create_nat = true
  create_igw = true

  igwname = "my-igw"
  natname = "my-nat"
  rtname  = "my-rt"
}
```
#

- IPV6

```hcl
module "vpc" {
  source = "github.com/Emerson89/vpc-aws-terraform.git?ref=v2.0.0"

  name                 = "my-vpc"
  cidr_block           = "10.30.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  create_aws_flow_log = true

  tags = {
    Environment = "hml"
  }
  environment = "hml"

  ## if a prefix ending in /16 and a newbit value of 4 is provided, the resulting subnet address will have length /20 (default is 4) that enables 4094 hosts and 16 subnets
  newbits = 4
  ## Sequence of subnets by zones starting with 0 = us-east-1a, 1 = us-east-1b..., respecting the sequence to not underlay the nets
  private_subnets      = [0, 1, 2]
  public_subnets       = [3, 4, 5]
  additional_subnets   = [6, 7, 8]
  route_nat_additional = true

  enable_ipv6                      = true
  assign_generated_ipv6_cidr_block = true
  public_subnet_ipv6_prefix        = [0, 1, 2]
  private_subnet_ipv6_prefix       = [3, 4, 5]
  create_additional_subnet_ipv6    = true
  additional_subnet_ipv6_prefix    = [6, 7, 8]

  create_route_private = false
  routes_private = {
    private_route1 = {
      destination_cidr_block    = "172.31.0.0/16"
      vpc_peering_connection_id = "pcx-xxxxxxxxxxx"
    }
  }

  create_route_public = false
  routes_public = {
    public_route1 = {
      destination_cidr_block    = "172.31.0.0/16"
      vpc_peering_connection_id = "pcx-xxxxxxxxxxx"
    }
  }

  create_route_additional = false
  routes_add = {
    add_route1 = {
      destination_cidr_block    = "172.31.0.0/16"
      vpc_peering_connection_id = "pcx-xxxxxxxxxxx"
    }
  }

  create_nat = true
  create_igw = true

  igwname = "my-igw"
  natname = "my-nat"
  rtname  = "my-rt"
}
```

#
More in examples
#

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_eip.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_flow_log.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/flow_log) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_internet_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_nat_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_route.additional_internet_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.additional_internet_gateway_ipv6](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.additional_nat](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.additional_nat_ipv6](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.dynamic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.private_nat](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.private_nat_ipv6](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.public_internet_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.public_internet_gateway_ipv6](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route_table.additional](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.additional](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_subnet.additional](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_availability_zones.azs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_iam_policy_document.assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_subnet_ipv6_prefix"></a> [additional\_subnet\_ipv6\_prefix](#input\_additional\_subnet\_ipv6\_prefix) | Assigns IPv6 public subnet id based on the Amazon provided /56 prefix base 10 integer (0-256). Must be of equal length to the corresponding IPv4 subnet list | `list(string)` | `[]` | no |
| <a name="input_additional_subnets"></a> [additional\_subnets](#input\_additional\_subnets) | A list of private subnets inside the VPC | `list(string)` | `[]` | no |
| <a name="input_additional_subnets_tags"></a> [additional\_subnets\_tags](#input\_additional\_subnets\_tags) | A mapping of tags to assign to the resource | `map(any)` | `{}` | no |
| <a name="input_assign_generated_ipv6_cidr_block"></a> [assign\_generated\_ipv6\_cidr\_block](#input\_assign\_generated\_ipv6\_cidr\_block) | Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length for the VPC. You cannot specify the range of IP addresses, or the size of the CIDR block. Default is false | `bool` | `false` | no |
| <a name="input_cidr_block"></a> [cidr\_block](#input\_cidr\_block) | The IPv4 CIDR block for the VPC. | `string` | n/a | yes |
| <a name="input_create_additional_subnet_ipv6"></a> [create\_additional\_subnet\_ipv6](#input\_create\_additional\_subnet\_ipv6) | Create subnet additional ipv6 | `bool` | `false` | no |
| <a name="input_create_aws_flow_log"></a> [create\_aws\_flow\_log](#input\_create\_aws\_flow\_log) | Create vpc flow log | `bool` | `false` | no |
| <a name="input_create_igw"></a> [create\_igw](#input\_create\_igw) | Create igw-gateway | `bool` | `true` | no |
| <a name="input_create_nat"></a> [create\_nat](#input\_create\_nat) | Create nat-gateway | `bool` | `true` | no |
| <a name="input_create_route_additional"></a> [create\_route\_additional](#input\_create\_route\_additional) | Boolean to create add routes | `bool` | `false` | no |
| <a name="input_create_route_private"></a> [create\_route\_private](#input\_create\_route\_private) | Boolean to create private routes | `bool` | `false` | no |
| <a name="input_create_route_public"></a> [create\_route\_public](#input\_create\_route\_public) | Boolean to create public routes | `bool` | `false` | no |
| <a name="input_enable_dns_hostnames"></a> [enable\_dns\_hostnames](#input\_enable\_dns\_hostnames) | Enable dns hostnames | `bool` | `true` | no |
| <a name="input_enable_dns_support"></a> [enable\_dns\_support](#input\_enable\_dns\_support) | Enable dns support | `bool` | `true` | no |
| <a name="input_enable_ipv6"></a> [enable\_ipv6](#input\_enable\_ipv6) | Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length for the VPC. You cannot specify the range of IP addresses, or the size of the CIDR block | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Env resources | `string` | `"hmg"` | no |
| <a name="input_igwname"></a> [igwname](#input\_igwname) | Name to be used the resources as identifier | `string` | `"igw"` | no |
| <a name="input_instance_tenancy"></a> [instance\_tenancy](#input\_instance\_tenancy) | A tenancy option for instances launched into the VPC. Default is default | `string` | `"default"` | no |
| <a name="input_map_public_ip_on_launch"></a> [map\_public\_ip\_on\_launch](#input\_map\_public\_ip\_on\_launch) | Should be false if you do not want to auto-assign public IP on launch | `bool` | `true` | no |
| <a name="input_name"></a> [name](#input\_name) | Name to be used on all the resources as identifier | `string` | n/a | yes |
| <a name="input_natname"></a> [natname](#input\_natname) | Name to be used the resources as identifier | `string` | `"nat"` | no |
| <a name="input_newbits"></a> [newbits](#input\_newbits) | Is the number of additional bits with which to extend the prefix. For example, if given a prefix ending in /16 and a newbits value of 4, the resulting subnet address will have length /20 | `number` | `4` | no |
| <a name="input_private_subnet_ipv6_prefix"></a> [private\_subnet\_ipv6\_prefix](#input\_private\_subnet\_ipv6\_prefix) | Assigns IPv6 public subnet id based on the Amazon provided /56 prefix base 10 integer (0-256). Must be of equal length to the corresponding IPv4 subnet list | `list(string)` | `[]` | no |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | A list of private subnets inside the VPC | `list(string)` | `[]` | no |
| <a name="input_private_subnets_tags"></a> [private\_subnets\_tags](#input\_private\_subnets\_tags) | A mapping of tags to assign to the resource | `map(any)` | `{}` | no |
| <a name="input_public_subnet_ipv6_prefix"></a> [public\_subnet\_ipv6\_prefix](#input\_public\_subnet\_ipv6\_prefix) | Assigns IPv6 public subnet id based on the Amazon provided /56 prefix base 10 integer (0-256). Must be of equal length to the corresponding IPv4 subnet list | `list(string)` | `[]` | no |
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | A list of public subnets inside the VPC | `list(string)` | `[]` | no |
| <a name="input_public_subnets_tags"></a> [public\_subnets\_tags](#input\_public\_subnets\_tags) | A mapping of tags to assign to the resource | `map(any)` | `{}` | no |
| <a name="input_route_igw_additional"></a> [route\_igw\_additional](#input\_route\_igw\_additional) | Routes igw subnets additional | `bool` | `false` | no |
| <a name="input_route_nat_additional"></a> [route\_nat\_additional](#input\_route\_nat\_additional) | Routes nat subnets additional | `bool` | `false` | no |
| <a name="input_routes_add"></a> [routes\_add](#input\_routes\_add) | Map of additional routes | `map(any)` | `{}` | no |
| <a name="input_routes_private"></a> [routes\_private](#input\_routes\_private) | Map of private routes | `map(any)` | `{}` | no |
| <a name="input_routes_public"></a> [routes\_public](#input\_routes\_public) | Map of public routes | `map(any)` | `{}` | no |
| <a name="input_rtname"></a> [rtname](#input\_rtname) | Name to be used the resources as identifier | `string` | `"rt"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the resource | `map(any)` | `{}` | no |
| <a name="input_traffic_type"></a> [traffic\_type](#input\_traffic\_type) | The type of traffic to capture. Valid values: ACCEPT,REJECT, ALL | `string` | `"ALL"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_additional_cidrs"></a> [additional\_cidrs](#output\_additional\_cidrs) | Output subnet additional |
| <a name="output_additional_ids"></a> [additional\_ids](#output\_additional\_ids) | Output subnet additional |
| <a name="output_igw"></a> [igw](#output\_igw) | Output vpc cidr |
| <a name="output_nat"></a> [nat](#output\_nat) | Output vpc cidr |
| <a name="output_private_cidrs"></a> [private\_cidrs](#output\_private\_cidrs) | Output subnet private |
| <a name="output_private_ids"></a> [private\_ids](#output\_private\_ids) | Output subnet private |
| <a name="output_private_ipv6_ids"></a> [private\_ipv6\_ids](#output\_private\_ipv6\_ids) | List of cidr\_blocks of public subnets |
| <a name="output_public_cidrs"></a> [public\_cidrs](#output\_public\_cidrs) | Output subnet public |
| <a name="output_public_ids"></a> [public\_ids](#output\_public\_ids) | Output subnet public |
| <a name="output_public_ipv6_ids"></a> [public\_ipv6\_ids](#output\_public\_ipv6\_ids) | List of IPv6 cidr\_blocks of public subnets in an IPv6 enabled VPC |
| <a name="output_vpc_cidr"></a> [vpc\_cidr](#output\_vpc\_cidr) | Output vpc cidr |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | Output vpc id |
| <a name="output_vpc_ipv6_cidr_block"></a> [vpc\_ipv6\_cidr\_block](#output\_vpc\_ipv6\_cidr\_block) | The IPv6 CIDR block |
| <a name="output_vpc_name"></a> [vpc\_name](#output\_vpc\_name) | Output vpc name |
