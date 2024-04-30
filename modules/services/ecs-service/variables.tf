# Sets tags for ecs cluster

variable "tags" {
  type        = map(string)
  description = "Tags for resources"
}

# subnets 

variable "ecs_vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "ecs_vpc_subnets_private_ids" {
  type        = list(string)
  description = "List of VPC subnets where workload is to be deployed."
}

# task image

variable "image" {
  type        = string
  default     = "quay.io/deepfenceio/cloud-scanner:2.2.0"
  description = "Image of the Deepfence cloud scanner to deploy"
}

# task resource limit

variable "container_cpu" {
  type        = string
  description = "Amount of CPU (in CPU units) to reserve for cloud-scanner task"
  default     = "4096"
}

variable "container_memory" {
  type        = string
  description = "Amount of memory (in megabytes) to reserve for cloud-scanner task"
  default     = "8192"
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
    condition     = contains(["arn:aws:iam::aws:policy/SecurityAudit", "arn:aws:iam::aws:policy/ReadOnlyAccess"], var.task_role)
    error_message = "Must be either \"arn:aws:iam::aws:policy/SecurityAudit\" or \"arn:aws:iam::aws:policy/ReadOnlyAccess\"."
  }
}

variable "debug_logs" {
  type        = bool
  default     = false
  description = "Enable debug logs"
}

# general

variable "name" {
  type        = string
  description = "Name prefix fo resources"
}

variable "service_desired_count" {
  description = "Number of services running in parallel"
  default = 1
}

variable "ecs_cluster_name" {
  type        = string
  description = "Name of a pre-existing ECS (elastic container service) cluster"
}

variable "aws-region" {
  description = "the AWS region in which resources are created, you must set the availability_zones variable as well if you define this value to something other than the default"
}

variable "cloudwatch_log_retention" {
  type        = number
  default     = 5
  description = "Days to keep logs for cloud scanner"
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
}

variable "mgmt-console-port" {
  type        = string
  description = "mgmt-console-port"
}

variable "deepfence-key" {
  type        = string
  sensitive   = true
  description = "deepfence-key"
}

variable "multiple-acc-ids" {
  type        = string
  description = "These account ids are those where scanning will be done"
}

variable "org-acc-id" {
  type        = string
  description = "This account id is the management account id which is there in an organizational setup"
}

# organisational setup

variable "is_organizational" {
  type        = bool
  default     = false
  description = "whether Deepfence cloud scanner should be deployed in an organizational setup"
}

variable "ecs_task_role_name" {
  type        = string
  default     = "ECSTaskRole"
  description = "Default ecs task role name"
}

variable "organizational_config" {
  type = object({
    mem_acc_ecs_task_role_name     = string
  })
  default = {
    mem_acc_ecs_task_role_name     = null
  }

  description = <<-EOT
    <ul>
      <li>`mem_acc_ecs_task_role_name` name of role created for ecs task</li>
    </ul>
  EOT
}

variable "cloudtrail_trails" {
  type        = list(string)
  description = "List of CloudTrail Trail ARNs (Management events with write-only or read-write). e.g.: [\"arn:aws:cloudtrail:us-east-1:123456789012:trail/aws-events\"]. If empty, a trail with management events will be automatically chosen if available."
}