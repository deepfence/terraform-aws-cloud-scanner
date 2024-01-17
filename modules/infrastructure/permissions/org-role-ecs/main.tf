# creates a role in management account

resource "aws_iam_role" "ccs_mgmt_acc_role" {
  count              = var.is_org ? 1 : 0
  name               = "${var.name}-mgmt-acc-role"
  assume_role_policy = data.aws_iam_policy_document.ccs_mgmt_acc_role_trusted.json
  tags               = var.tags
}

# ---------------------------------------------
# enable deepfence-cloud-scanner module ECS Task role to AssumeRole on ccs_mgmt_acc_role
# ---------------------------------------------

# trust ecs-task-role identifier to assumeRole in mgmt account

data "aws_iam_role" "ecs_task_role" {
  provider = aws.member
  name     = var.ccs_ecs_task_role_name
}

data "aws_iam_policy_document" "ccs_mgmt_acc_role_trusted" {
  statement {
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = [
        data.aws_iam_role.ecs_task_role.arn
      ]
    }
    actions = ["sts:AssumeRole"]
  }
}

# enable ecs-task resource to assumeRole in ccs member account

resource "aws_iam_role_policy" "enable_assume_ccs_mgmt_acc_role" {
  provider = aws.member
  name     = "${var.name}-EnableCCSMgmtAccRole"

  role   = var.ccs_ecs_task_role_name
  policy = data.aws_iam_policy_document.enable_assume_secure_for_cloud_role.json
}

data "aws_iam_policy_document" "enable_assume_secure_for_cloud_role" {
  statement {
    effect  = "Allow"
    actions = [
      "sts:AssumeRole"
    ]
    resources = [aws_iam_role.ccs_mgmt_acc_role[0].arn]
  }
}

# ---------------------------------------------------------------------------------
# enable mgmt account role to have read only access to all resource in mgmt account
# ---------------------------------------------------------------------------------

# policy attachment

resource "aws_iam_role_policy_attachment" "ecs-task-role-policy-attachment" {
  role       = aws_iam_role.ccs_mgmt_acc_role[0].id
  policy_arn = var.task_role
}

# -----------------------------------------------------------------
# enable role in mgmt account to access all member accounts
# -----------------------------------------------------------------

# role-policy binding

resource "aws_iam_role_policy" "mem_acc_assume_role" {
  name   = "${var.name}-AllowAssumeRoleInChildAccounts"
  role   = aws_iam_role.ccs_mgmt_acc_role[0].id
  policy = data.aws_iam_policy_document.mem_acc_assume_role.json
}

# policy allows to assume role in all member accounts

data "aws_iam_policy_document" "mem_acc_assume_role" {
  statement {
    effect  = "Allow"
    actions = [
      "sts:AssumeRole",
    ]
    resources = [
      "arn:aws:iam::*:role/${var.organizational_role_per_account}"
    ]
  }
}