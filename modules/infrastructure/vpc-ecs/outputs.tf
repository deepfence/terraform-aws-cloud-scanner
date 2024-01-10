# Outputs VPC resource details

output "ecs_vpc_id" {
  value       = var.use_existing_vpc == true ? var.existing_vpc_id : module.vpc[0].vpc_id
  description = "ID of the VPC for the ECS cluster"
}

output "ecs_vpc_subnets_private_ids" {
  value       = var.use_existing_vpc == true ? var.existing_vpc_subnet_ids : module.vpc[0].private_subnets
  description = "IDs of the private subnets of the VPC for the ECS cluster"
}

output "ecs_cluster_name" {
  value       = aws_ecs_cluster.ecs_cluster.id
  description = "ID of the ECS cluster"
}
