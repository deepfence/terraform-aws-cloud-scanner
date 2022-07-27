provider "aws" {
  region = var.region
}

# creates resource group for the resources

module "resource_group" {
  source = "../../modules/infrastructure/resource-group"

  name = var.name
  tags = var.tags
}

# module creates vpc and ecs cluster

module "vpc-ecs" {
  source             = "../../modules/infrastructure/vpc-ecs"
  ecs_vpc_region_azs = var.ecs_vpc_region_azs
  tags               = var.tags
}

# module creates ecs service with container

module "ecs-service" {
  source                        = "../../modules/services/ecs-service"
  aws-region                    = var.region
  ecs_vpc_subnets_private_ids   = module.vpc-ecs.ecs_vpc_subnets_private_ids
  ecs_cluster_name              = "${var.name}-ecs-cluster"
  tags                          = var.tags
  mode                          = var.mode
  mgmt-console-url              = var.mgmt-console-url 
  mgmt-console-port             = var.mgmt-console-port
  deepfence-key                 = var.deepfence-key
}



