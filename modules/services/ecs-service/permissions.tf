locals {
  ecs_task_role_id          = var.is_organizational ? data.aws_iam_role.task_inherited[0].id : aws_iam_role.deepfence-cloud-scanner-all-resource-read-only-access-role[0].id
  ecs_task_role_arn         = var.is_organizational ? data.aws_iam_role.task_inherited[0].arn : aws_iam_role.deepfence-cloud-scanner-all-resource-read-only-access-role[0].arn
  ecs_task_role_name_suffix = var.is_organizational ? var.organizational_config.mem_acc_ecs_task_role_name : var.ecs_task_role_name
}

# task execution access for ecs ( required for both org and single account)

# Importing policy

data "aws_iam_policy_document" "execution_assume_role" {
  statement {
    effect = "Allow"
    principals {
      identifiers = ["ecs-tasks.amazonaws.com"]
      type        = "Service"
    }
    actions = ["sts:AssumeRole"]
  }
}

# policy attachment

resource "aws_iam_role_policy_attachment" "ecs_tasks_execution_role" {
  role       = "${aws_iam_role.execution.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

#--------------------------------------------------------------------------
# This role is required by tasks to pull container images and publish 
# container logs to Amazon CloudWatch on your behalf.
#--------------------------------------------------------------------------


# role creation

resource "aws_iam_role" "execution" {
  name               = "${var.name}-ECSTaskExecutionRole"
  assume_role_policy = data.aws_iam_policy_document.execution_assume_role.json
  tags               = var.tags
}

# organisational access

# importing ecs task role 

data "aws_iam_role" "task_inherited" {
  count = var.is_organizational ? 1 : 0
  name  = var.organizational_config.mem_acc_ecs_task_role_name
}

# single account access

#---------------------------------
# This role gives read only access to all resources
#---------------------------------

# role creation

resource "aws_iam_role" "deepfence-cloud-scanner-all-resource-read-only-access-role" {
  count              = var.is_organizational ? 0 : 1
  name               = "${var.name}-all-resource-read-only-access-role"
  tags               = var.tags
  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ecs-tasks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

# importing managed policy

data "aws_iam_policy" "ReadOnlyAccess" {
  arn = "arn:aws:iam::aws:policy/ReadOnlyAccess" 
}


# policy attachment

resource "aws_iam_role_policy_attachment" "ecs-task-role-policy-attachment" {
  count      = var.is_organizational ? 0 : 1
  role       = local.ecs_task_role_id
  policy_arn = data.aws_iam_policy.ReadOnlyAccess.arn
}

