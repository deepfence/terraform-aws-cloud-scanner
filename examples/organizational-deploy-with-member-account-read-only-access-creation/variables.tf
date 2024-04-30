# common variables

variable "name" {
  type        = string
  description = "Prefix name for all resources"
}

variable "tags" {
  type        = map(string)
  description = "Default tag for resource"
}

# variable to store availability Zones

variable "ecs_vpc_region_azs" {
  type        = list(string)
  description = "List of Availability Zones for ECS VPC creation. e.g.: [\"apne1-az1\", \"apne1-az2\"]. If defaulted, two of the default 'aws_availability_zones' datasource will be taken"
  default     = []
}

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
  sensitive   = true
  default     = ""
}

variable "multiple-acc-ids" {
  type        = string
  description = "These account ids are those where scanning will be done"
  default     = ""
}

variable "mem_acc_ecs_task_role_name" {
  type        = string
  default     = ""
  description = "Name for the ecs task role. This is only required to resolve cyclic dependency with organizational approach"
}

variable "image" {
  type        = string
  default     = "quay.io/deepfenceio/cloud-scanner:2.2.0"
  description = "Image of the Deepfence cloud scanner to deploy"
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

variable "cpu" {
  type        = string
  default     = "8192"
  description = "Task CPU Units (Default: 8 vCPU)"
}

variable "memory" {
  type        = string
  default     = "16384"
  description = "Task Memory (Default: 16 GB)"
}

variable "ephemeral_storage" {
  type        = string
  default     = "100"
  description = "Task Ephemeral Storage (Default: 100 GB)"
}

variable "task_role" {
  type        = string
  default     = "arn:aws:iam::aws:policy/SecurityAudit"
  description = "Task Role (arn:aws:iam::aws:policy/SecurityAudit or arn:aws:iam::aws:policy/ReadOnlyAccess)"
  validation {
    condition = contains([
      "arn:aws:iam::aws:policy/SecurityAudit", "arn:aws:iam::aws:policy/ReadOnlyAccess"
    ], var.task_role)
    error_message = "Must be either \"arn:aws:iam::aws:policy/SecurityAudit\" or \"arn:aws:iam::aws:policy/ReadOnlyAccess\"."
  }
}

variable "debug_logs" {
  type        = bool
  default     = false
  description = "Enable debug logs"
}

variable "cloudtrail_trails" {
  type        = list(string)
  description = "List of CloudTrail Trail ARNs (Management events with write-only or read-write). e.g.: [\"arn:aws:cloudtrail:us-east-1:123456789012:trail/aws-events\"]. If empty, a trail with management events will be automatically chosen if available."
}