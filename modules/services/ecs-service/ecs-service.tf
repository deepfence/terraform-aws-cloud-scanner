# imports aws region

data "aws_region" "current" {}

# creates ecs service

resource "aws_ecs_service" "service" {
  name            = "${var.name}-ecs-service"
  cluster         = var.ecs_cluster_name
  desired_count   = var.service_desired_count
  launch_type     = "FARGATE"
  task_definition = aws_ecs_task_definition.task_definition.arn
  tags            = var.tags

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  network_configuration {
    subnets          = var.ecs_vpc_subnets_private_ids
    assign_public_ip = true
    security_groups  = aws_security_group.ecs_security_group.*.id
  }

  lifecycle {
    ignore_changes = [task_definition, desired_count]
  }

}

# Task definition for deploying image in container

resource "aws_ecs_task_definition" "task_definition" {
  family                   = "${var.name}-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.execution.arn
  # ARN of the task execution role that the Amazon ECS container agent and the Docker daemon can assume
  task_role_arn            = local.ecs_task_role_arn
  # ARN of IAM role that allows your Amazon ECS container task to make calls to other AWS services.
  cpu                      = var.container_cpu
  memory                   = var.container_memory
  tags                     = var.tags
  ephemeral_storage {
    size_in_gib = var.ephemeral_storage
  }

  container_definitions = jsonencode([
    {
      name      = "${var.name}-container"
      image     = var.image
      essential = true
      tags      = var.tags
      name      = var.name

      environment = [
        { "name" : "MGMT_CONSOLE_URL", "value" : var.mgmt-console-url },
        { "name" : "MGMT_CONSOLE_PORT", "value" : var.mgmt-console-port },
        { "name" : "DEEPFENCE_KEY", "value" : var.deepfence-key },
        { "name" : "CLOUD_PROVIDER", "value" : "aws" },
        { "name" : "CLOUD_REGION", "value" : var.aws_region },
        { "name" : "CLOUD_ACCOUNT_ID", "value" : var.account_id },
        { "name" : "DEPLOYED_ACCOUNT_ID", "value" : var.deployed_account_id },
        { "name" : "CLOUD_ACCOUNT_NAME", "value" : var.account_name },
        { "name" : "CLOUD_ORGANIZATION_ID", "value" : var.account_id },
        { "name" : "ORGANIZATION_DEPLOYMENT", "value" : tostring(var.is_organizational) },
        { "name" : "ROLE_NAME", "value" : var.name },
        { "name" : "AWS_CREDENTIAL_SOURCE", "value" : "EcsContainer" },
        { "name" : "CLOUD_AUDIT_LOGS_ENABLED", "value" : tostring(var.enable_cloudtrail_trails) },
        { "name" : "CLOUD_AUDIT_LOG_IDS", "value" : join(",", var.cloudtrail_trails) },
        { "name" : "HTTP_SERVER_REQUIRED", "value" : "false" },
        { "name" : "SUCCESS_SIGNAL_URL", "value" : "" },
        { "name" : "LOG_LEVEL", "value" : var.log_level },
        { "name" : "SCAN_INACTIVE_THRESHOLD", "value" : "21600" },
        { "name" : "CLOUD_SCANNER_POLICY", "value" : var.task_role },
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options   = {
          awslogs-group         = aws_cloudwatch_log_group.log.id
          awslogs-region        = data.aws_region.current.name
          awslogs-stream-prefix = "deepfence-cloud-scanner"
        }
      }
    },

  ])
}




