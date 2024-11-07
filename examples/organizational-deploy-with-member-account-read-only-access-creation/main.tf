# module creates resource group

module "resource_group" {
  providers = {
    aws = aws.member
  }
  source = "../../modules/infrastructure/resource-group"
  name   = var.name
  tags   = var.tags
}

# module creates vpc and ecs cluster

module "vpc-ecs" {
  providers = {
    aws = aws.member
  }

  source                  = "../../modules/infrastructure/vpc-ecs"
  ecs_vpc_region_azs      = var.ecs_vpc_region_azs
  name                    = var.name
  use_existing_vpc        = var.use_existing_vpc
  existing_vpc_id         = var.existing_vpc_id
  existing_vpc_subnet_ids = var.existing_vpc_subnet_ids
  tags                    = var.tags
}

# module creates ecs service with container

module "ecs-service" {
  providers = {
    aws = aws.member
  }
  is_organizational     = true
  organizational_config = {
    mem_acc_ecs_task_role_name = aws_iam_role.ccs_ecs_task_role.name
  }

  source                      = "../../modules/services/ecs-service"
  aws_region                  = var.region
  ecs_vpc_id                  = module.vpc-ecs.ecs_vpc_id
  ecs_vpc_subnets_private_ids = module.vpc-ecs.ecs_vpc_subnets_private_ids
  ecs_cluster_name            = "${var.name}-ecs-cluster"
  name                        = var.name
  tags                        = var.tags
  mode                        = var.mode
  mgmt-console-url            = var.mgmt-console-url
  mgmt-console-port           = var.mgmt-console-port
  deepfence-key               = var.deepfence-key
  image                       = var.image
  container_cpu               = var.cpu
  container_memory            = var.memory
  ephemeral_storage           = var.ephemeral_storage
  task_role                   = var.task_role
  log_level                   = var.log_level
  account_id                  = data.aws_caller_identity.me.account_id
  deployed_account_id         = var.deployed_account_id
  account_name                = ""
  enable_cloudtrail_trails    = var.enable_cloudtrail_trails
  cloudtrail_trails           = var.cloudtrail_trails

  depends_on = [aws_iam_role.ccs_ecs_task_role]

}


