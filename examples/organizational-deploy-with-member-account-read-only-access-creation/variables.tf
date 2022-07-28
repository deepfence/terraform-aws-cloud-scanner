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
  default     = []
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

variable "mem_acc_ecs_task_role_name" {
  type        = string
  default     = ""
  description = "Name for the ecs task role. This is only required to resolve cyclic dependency with organizational approach"
}

# organizational setup variables

variable "ccs_ecs_task_role_name" {
  type        = string
  default     = "organizational-ECSTaskRole"
  description = "Name for the ecs task role. This is only required to resolve cyclic dependency with organizational approach"
}

variable "role_in_all_account_to_be_scanned" {
  type        = string
  default     = "deepfence-cloud-scanner-mem-acc-read-only-access"
  description = "Default role created by AWS for management-account users to be able to admin member accounts.<br/>https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_accounts_access.html"
}

variable "CCS_member_account_id" {
  type        = string
  default     = ""
  description = "Member Account ID where scanner resources will be deployed"
}





