# ECS Service and Task defintion

This module deploys Deepfence cloud scanner image in a container with the required permissions.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.15.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.50.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.50.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_stream.stream](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_stream) | resource |
| [aws_ecs_service.service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.task_definition](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_iam_role.deepfence-cloud-scanner](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.execution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.ecs-task-role-policy-attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ecs_tasks_execution_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_policy.SecurityAudit](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |
| [aws_iam_policy_document.execution_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_role.task_inherited](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_role) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name                                                                                                                        | Description | Type | Default | Required |
|-----------------------------------------------------------------------------------------------------------------------------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws_region](#input\_aws_region)                                                            | the AWS region in which resources are created, you must set the availability\_zones variable as well if you define this value to something other than the default | `any` | n/a | yes |
| <a name="input_cloudwatch_log_retention"></a> [cloudwatch\_log\_retention](#input\_cloudwatch\_log\_retention)              | Days to keep logs for cloud scanner | `number` | `5` | no |
| <a name="input_container_cpu"></a> [container\_cpu](#input\_container\_cpu)                                                 | Amount of CPU (in CPU units) to reserve for cloud-scanner task | `string` | `"1024"` | no |
| <a name="input_container_memory"></a> [container\_memory](#input\_container\_memory)                                        | Amount of memory (in megabytes) to reserve for cloud-scanner task | `string` | `"2048"` | no |
| <a name="input_deepfence-key"></a> [deepfence-key](#input\_deepfence-key)                                                   | deepfence-key | `string` | n/a | yes |
| <a name="input_ecs_cluster_name"></a> [ecs\_cluster\_name](#input\_ecs\_cluster\_name)                                      | Name of a pre-existing ECS (elastic container service) cluster | `string` | n/a | yes |
| <a name="input_ecs_task_role_name"></a> [ecs\_task\_role\_name](#input\_ecs\_task\_role\_name)                              | Default ecs task role name | `string` | `"ECSTaskRole"` | no |
| <a name="input_ecs_vpc_subnets_private_ids"></a> [ecs\_vpc\_subnets\_private\_ids](#input\_ecs\_vpc\_subnets\_private\_ids) | List of VPC subnets where workload is to be deployed. | `list(string)` | n/a | yes |
| <a name="input_image"></a> [image](#input\_image)                                                                           | Image of the Deepfence cloud scanner to deploy | `string` | `"quay.io/deepfenceio/cloud_scanner_ce:2.5.1"` | no |
| <a name="input_is_organizational"></a> [is\_organizational](#input\_is\_organizational)                                     | whether Deepfence cloud scanner should be deployed in an organizational setup | `bool` | `false` | no |
| <a name="input_mgmt-console-port"></a> [mgmt-console-port](#input\_mgmt-console-port)                                       | mgmt-console-port | `string` | n/a | yes |
| <a name="input_mgmt-console-url"></a> [mgmt-console-url](#input\_mgmt-console-url)                                          | mgmt-console-url | `string` | n/a | yes |
| <a name="input_mode"></a> [mode](#input\_mode)                                                                              | mode | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name)                                                                              | Name prefix fo resources | `string` | n/a | yes |
| <a name="input_organizational_config"></a> [organizational\_config](#input\_organizational\_config)                         | <ul><br>  <li>`mem_acc_ecs_task_role_name` name of role created for ecs task</li><br></ul> | <pre>object({<br>    mem_acc_ecs_task_role_name     = string<br>  })</pre> | <pre>{<br>  "mem_acc_ecs_task_role_name": null<br>}</pre> | no |
| <a name="input_service_desired_count"></a> [service\_desired\_count](#input\_service\_desired\_count)                       | Number of services running in parallel | `number` | `1` | no |
| <a name="input_tags"></a> [tags](#input\_tags)                                                                              | Tags for resources | `map(string)` | n/a | yes |

## Outputs

No outputs.
