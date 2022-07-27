# creates ecs cluster

resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.name}-ecs-cluster"
  tags = var.tags
}
