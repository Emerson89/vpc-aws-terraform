module "vpc" {
  source = "github.com/Emerson89/vpc-aws-terraform.git?ref=v2.1.0"

  name       = "my-vpc"
  cidr_block = "172.31.0.0/16"

  tags = {
    Environment = "hml"
  }
  environment = "hml"

  create_nat = true
  create_igw = true
  
  private_subnets = ["172.31.0.0/20", "172.31.16.0/20", "172.31.32.0/20"]
  public_subnets  = ["172.31.48.0/20", "172.31.64.0/20", "172.31.80.0/20"]
}
