# Creates VPC

data "aws_availability_zones" "zones" {
}

# https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest
module "vpc" {
  count   = var.use_existing_vpc ? 0 : 1
  source  = "terraform-aws-modules/vpc/aws"
  version = ">=5.0.0"
  name    = "${var.name}-vpc"

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

  manage_default_security_group = var.manage_default_security_group
  default_security_group_egress = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  default_security_group_ingress = [
    {
      from_port = 0
      to_port   = 0
      protocol  = "-1"
      self      = true
    }
  ]
  default_security_group_name = "${var.name}-sg"
  default_security_group_tags = var.tags
}
