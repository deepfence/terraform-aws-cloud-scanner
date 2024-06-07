# creates a role in member account where Deepfence cloud scanner resources will be deployed

resource "aws_iam_role" "ccs_ecs_task_role" {
  provider           = aws.member
  name               = "${var.name}-${var.ccs_ecs_task_role_name}"
  assume_role_policy = data.aws_iam_policy_document.task_assume_role.json
  path               = "/"
  tags               = var.tags
}

# allows ecs task to assume role created in member account where
# Deepfence cloud scanner resources will be deployed

data "aws_iam_policy_document" "task_assume_role" {
  provider = aws.member
  statement {
    effect = "Allow"
    principals {
      identifiers = ["ecs-tasks.amazonaws.com"]
      type        = "Service"
    }
    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "mem_acc_assume_role" {
  provider = aws.member
  statement {
    effect  = "Allow"
    actions = [
      "sts:AssumeRole",
    ]
    resources = [
      "arn:aws:iam::*:role/${var.name}"
    ]
  }
}

resource "aws_iam_role_policy" "mem_acc_assume_role" {
  provider = aws.member
  name     = "${var.name}-AllowAssumeRoleInChildAccounts"
  role     = aws_iam_role.ccs_ecs_task_role.id
  policy   = data.aws_iam_policy_document.mem_acc_assume_role.json
}

# policy attachment

resource "aws_iam_role_policy_attachment" "ecs-task-role-policy-attachment" {
  provider   = aws.member
  role       = aws_iam_role.ccs_ecs_task_role.id
  policy_arn = var.task_role
}
