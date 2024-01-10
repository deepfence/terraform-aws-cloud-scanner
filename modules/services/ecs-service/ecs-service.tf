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
      command   = [
        "-mode", var.mode, "-mgmt-console-url", var.mgmt-console-url, "-mgmt-console-port", var.mgmt-console-port,
        "-deepfence-key", var.deepfence-key, "-multiple-acc-ids", var.multiple-acc-ids, "-org-acc-id", var.org-acc-id,
        "-role-prefix", var.name, "-debug", tostring(var.debug_logs)
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




