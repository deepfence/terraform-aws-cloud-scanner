# Creates VPC

data "aws_availability_zones" "zones" {
}

# https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = ">=3.14.0"
  name = "${var.name}-vpc"

  cidr = "10.0.0.0/16"

  private_subnets         = ["10.0.1.0/24"]
  public_subnets          = ["10.0.101.0/24"]
  map_public_ip_on_launch = false

  azs = length(var.ecs_vpc_region_azs) > 0 ? var.ecs_vpc_region_azs : [
    data.aws_availability_zones.zones.names[0],
    data.aws_availability_zones.zones.names[1]
  ]

  enable_dns_hostnames = true
  enable_dns_support   = true
  enable_nat_gateway   = true
  enable_vpn_gateway   = false

  tags = var.tags
}
