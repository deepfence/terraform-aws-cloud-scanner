# Sets tags for ecs cluster

variable "tags" {
  type        = map(string)
  description = "Tags for resources"
}

# subnets 

variable "ecs_vpc_subnets_private_ids" {
  type        = list(string)
  description = "List of VPC subnets where workload is to be deployed."
}

# task image

variable "image" {
  type        = string
  default     = "deepfenceio/cloud-scanner:latest"
  description = "Image of the Deepfence cloud scanner to deploy"
}

# task resource limit

variable "container_cpu" {
  type        = string
  description = "Amount of CPU (in CPU units) to reserve for cloud-scanner task"
  default     = "1024"
}

variable "container_memory" {
  type        = string
  description = "Amount of memory (in megabytes) to reserve for cloud-scanner task"
  default     = "2048"
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
