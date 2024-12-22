module "vpc" {
  source = "github.com/Emerson89/vpc-aws-terraform.git?ref=v2.0.0"

  name       = "my-vpc"
  cidr_block = "10.10.0.0/16"

  tags = {
    Environment = "hml"
  }
  environment = "hml"

  create_nat = false
  create_igw = false

  ## Sequence of subnets by zones starting with 0 = us-east-1a, 1 = us-east-1b..., respecting the sequence to not underlay the nets
  private_subnets = [0, 1, 2]
  public_subnets  = [3, 4, 5]
}
