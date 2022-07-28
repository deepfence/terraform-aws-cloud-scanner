# creates a role in management account

module "org-role-ecs" {
  source = "../../../modules/infrastructure/permissions/org-role-ecs"
  providers = {
    aws.member = aws.member
  }

  name                            = var.name
  ccs_ecs_task_role_name          = aws_iam_role.ccs_ecs_task_role.name
  organizational_role_per_account = var.organizational_member_default_admin_role

  tags       = var.tags
  depends_on = [aws_iam_role.ccs_ecs_task_role]
}

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


