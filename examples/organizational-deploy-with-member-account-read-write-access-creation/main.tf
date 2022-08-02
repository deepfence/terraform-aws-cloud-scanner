# module creates resource group

module "resource_group" {
  source = "../../modules/infrastructure/resource-group"
  name   = var.name
  tags   = var.tags
}

module "resource_group_secure_for_cloud_member" {
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

  source             = "../../modules/infrastructure/vpc-ecs"
  ecs_vpc_region_azs = var.ecs_vpc_region_azs
  name               = var.name
  tags               = var.tags
}

# module creates ecs service with container

module "ecs-service" {
  providers = {
    aws = aws.member
  }
  is_organizational = true
  organizational_config = {
    mgmt_acc_role_arn               = module.org-role-ecs.ccs_mgmt_acc_role_arn
    organizational_role_per_account = var.organizational_member_default_admin_role
    mem_acc_ecs_task_role_name      = aws_iam_role.ccs_ecs_task_role.name
  }

  source                      = "../../modules/services/ecs-service"
  aws-region                  = var.region
  ecs_vpc_subnets_private_ids = module.vpc-ecs.ecs_vpc_subnets_private_ids
  ecs_cluster_name            = "${var.name}-ecs-cluster"
  tags                        = var.tags
  name                        = var.name
  mode                        = var.mode
  mgmt-console-url            = var.mgmt-console-url
  mgmt-console-port           = var.mgmt-console-port
  deepfence-key               = var.deepfence-key
  multiple-acc-ids            = var.multiple-acc-ids
  org-acc-id                  = var.org-acc-id

  depends_on = [aws_iam_role.ccs_ecs_task_role]

}



