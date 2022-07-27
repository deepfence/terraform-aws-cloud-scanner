# Outputs VPC resource details

output "ecs_vpc_id" {
  value       = module.vpc.vpc_id
  description = "ID of the VPC for the ECS cluster"
}

output "ecs_vpc_subnets_private_ids" {
  value       = module.vpc.private_subnets
  description = "IDs of the private subnets of the VPC for the ECS cluster"
}

output "ecs_cluster_name" {
  value       = aws_ecs_cluster.ecs_cluster.id
  description = "ID of the ECS cluster"
}
