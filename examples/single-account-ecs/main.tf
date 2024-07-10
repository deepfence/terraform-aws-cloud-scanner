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
  source                        = "../../modules/infrastructure/vpc-ecs"
  ecs_vpc_region_azs            = var.ecs_vpc_region_azs
  tags                          = var.tags
  name                          = var.name
  use_existing_vpc              = var.use_existing_vpc
  existing_vpc_id               = var.existing_vpc_id
  existing_vpc_subnet_ids       = var.existing_vpc_subnet_ids
  manage_default_security_group = true
}

# module creates ecs service with container

module "ecs-service" {
  source                      = "../../modules/services/ecs-service"
  aws_region                  = var.region
  ecs_vpc_id                  = module.vpc-ecs.ecs_vpc_id
  ecs_vpc_subnets_private_ids = module.vpc-ecs.ecs_vpc_subnets_private_ids
  ecs_cluster_name            = "${var.name}-ecs-cluster"
  tags                        = var.tags
  mode                        = var.mode
  mgmt-console-url            = var.mgmt-console-url
  mgmt-console-port           = var.mgmt-console-port
  deepfence-key               = var.deepfence-key
  name                        = var.name
  image                       = var.image
  container_cpu               = var.cpu
  container_memory            = var.memory
  ephemeral_storage           = var.ephemeral_storage
  task_role                   = var.task_role
  log_level                   = var.log_level
  account_id                  = data.aws_caller_identity.me.account_id
  deployed_account_id         = data.aws_caller_identity.me.account_id
  account_name                = var.account_name
  cloudtrail_trails           = var.cloudtrail_trails
}



