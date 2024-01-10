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
  count     = var.use_existing_vpc ? 0 : 1
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
  aws-region                  = var.region
  ecs_vpc_subnets_private_ids = module.vpc-ecs.ecs_vpc_subnets_private_ids
  ecs_cluster_name            = "${var.name}-ecs-cluster"
  name                        = var.name
  tags                        = var.tags
  mode                        = var.mode
  mgmt-console-url            = var.mgmt-console-url
  mgmt-console-port           = var.mgmt-console-port
  deepfence-key               = var.deepfence-key
  multiple-acc-ids            = var.multiple-acc-ids
  image                       = var.image
  container_cpu               = var.cpu
  container_memory            = var.memory
  ephemeral_storage           = var.ephemeral_storage
  task_role                   = var.task_role
  debug_logs                  = var.debug_logs
  org-acc-id                  = data.aws_caller_identity.me.account_id

  depends_on = [aws_iam_role.ccs_ecs_task_role]

}


