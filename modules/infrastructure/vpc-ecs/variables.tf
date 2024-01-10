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

variable "use_existing_vpc" {
  type        = bool
  description = "Use existing VPC"
  default     = false
}

variable "existing_vpc_id" {
  type        = string
  description = "Existing VPC ID"
}

variable "existing_vpc_subnet_ids" {
  type        = list(string)
  description = "Existing VPC Subnet IDs"
}

variable "ecs_vpc_region_azs" {
  type        = list(string)
  description = "List of Availability Zones for ECS VPC creation. e.g.: [\"apne1-az1\", \"apne1-az2\"]. If defaulted, two of the default 'aws_availability_zones' datasource will be taken"
  default     = []
}

variable "manage_default_security_group" {
  type        = bool
  description = "Whether to manage default security group of VPC"
  default     = false
}
