## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_security_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.egress_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ingress_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.with_source_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_description"></a> [description](#input\_description) | Description of security group | `string` | `"Security Group managed by Terraform"` | no |
| <a name="input_egress"></a> [egress](#input\_egress) | n/a | `map(any)` | <pre>{<br>  "engress_rule": {<br>    "cidr_blocks": [<br>      "0.0.0.0/0"<br>    ],<br>    "from_port": "0",<br>    "protocol": "-1",<br>    "to_port": "0"<br>  }<br>}</pre> | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Env tags | `string` | `null` | no |
| <a name="input_ingress_with_cidr_blocks"></a> [ingress\_with\_cidr\_blocks](#input\_ingress\_with\_cidr\_blocks) | Ingress rules security group | `map(any)` | `{}` | no |
| <a name="input_ingress_with_source_security_group"></a> [ingress\_with\_source\_security\_group](#input\_ingress\_with\_source\_security\_group) | Ingress rules security group | `map(any)` | `{}` | no |
| <a name="input_sgname"></a> [sgname](#input\_sgname) | Name to be used the resources as identifier | `string` | n/a | yes |
| <a name="input_source_security_group_id"></a> [source\_security\_group\_id](#input\_source\_security\_group\_id) | Source security-group id | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the resource | `map(any)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC id | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_sg_id"></a> [sg\_id](#output\_sg\_id) | The ID of the security group |
| <a name="output_sg_name"></a> [sg\_name](#output\_sg\_name) | Output security group name |
