# common variables

variable "name" {
  type        = string
  description = "Prefix name for all resources"
  default     = "deepfence-cloud-scanner"
}

variable "tags" {
  type        = map(string)
  description = "Default tag for resource"
  default     = {
    product = "deepfence-cloud-scanner"
  }
}

variable "account_name" {
  type        = string
  description = "AWS account name"
  default     = ""
}

# variable to store availability Zones

variable "ecs_vpc_region_azs" {
  type        = list(string)
  description = "List of Availability Zones for ECS VPC creation. e.g.: [\"apne1-az1\", \"apne1-az2\"]. If defaulted, two of the default 'aws_availability_zones' datasource will be taken"
  default     = ["us-east-1a"]
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

variable "disabled_cloud_regions" {
  type        = list(string)
  description = "List of cloud regions which should not be scanned"
  default     = []
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

variable "image" {
  type        = string
  description = "Cloud Scanner image"
  default     = "quay.io/deepfenceio/cloud_scanner_ce:2.5.1"
}

variable "cpu" {
  type        = string
  default     = "4096"
  description = "Task CPU Units (Default: 4 vCPU)"
}

variable "memory" {
  type        = string
  default     = "8192"
  description = "Task Memory (Default: 8 GB)"
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

variable "log_level" {
  type        = string
  default     = "info"
  description = "Log level"
  validation {
    condition     = contains(["error", "warn", "info", "debug", "trace"], var.log_level)
    error_message = "Must be one of error, warn, info, debug, trace"
  }
}

variable "enable_cloudtrail_trails" {
  type        = bool
  default     = false
  description = "Enable CloudTrail based updates"
}

variable "cloudtrail_trails" {
  type        = list(string)
  description = "List of CloudTrail Trail ARNs (Management events with write-only or read-write). e.g.: [\"arn:aws:cloudtrail:us-east-1:123456789012:trail/aws-events\"]. If empty, a trail with management events will be automatically chosen if available."
}