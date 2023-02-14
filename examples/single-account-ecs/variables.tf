# common variables

variable "name" {
  type        = string
  description = "Prefix name for all resources"
  default     = "deepfence-cloud-scanner"
}

variable "tags" {
  type        = map(string)
  description = "Default tag for resource"
  default = {
    "product" = "deepfence-cloud-scanner"
  }
}

# variable to store availability Zones

variable "ecs_vpc_region_azs" {
  type        = list(string)
  description = "List of Availability Zones for ECS VPC creation. e.g.: [\"apne1-az1\", \"apne1-az2\"]. If defaulted, two of the default 'aws_availability_zones' datasource will be taken"
  default     = ["us-east-1a"]
}

# variable to store aws region

variable "region" {
  description = "the AWS region in which resources are created, you must set the availability_zones variable as well if you define this value to something other than the default"
  default     = "us-east-1"
}

# container variables

variable "mode" {
  type        = string
  description = "mode"
  default     = "service"
}

variable "mgmt-console-url" {
  type        = string
  description = "mgmt-console-url"
  default     = ""
}

variable "mgmt-console-port" {
  type        = string
  description = "mgmt-console-port"
  default     = "443"
}

variable "deepfence-key" {
  type        = string
  description = "deepfence-key"
  default     = ""
}

variable "image" {
  type        = string
  description = "Cloud Scanner image"
  default     = "quay.io/deepfenceio/cloud-scanner:latest"
}
