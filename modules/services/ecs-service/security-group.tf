resource "aws_security_group" "ecs_security_group" {
  description = format("%s ECS service", var.name)
  name        = trim("${var.name}securitygroup", "-_")
  vpc_id      = var.ecs_vpc_id
  tags        = var.tags
}

resource "aws_security_group_rule" "service_out" {
  description = "Allow outbound connections for all protocols and all ports for ECS service ${var.name}"

  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = -1
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.ecs_security_group.id
}