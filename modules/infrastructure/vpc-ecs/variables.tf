# general

variable "name" {
  type        = string
  description = "Prefix name for all resources"
}

variable "tags" {
  type        = map(string)
  description = "Default tag for resource"
}

# vpc 

variable "ecs_vpc_region_azs" {
  type        = list(string)
  description = "List of Availability Zones for ECS VPC creation. e.g.: [\"apne1-az1\", \"apne1-az2\"]. If defaulted, two of the default 'aws_availability_zones' datasource will be taken"
  default     = []
}