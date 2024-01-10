# Deepfence cloud scanner in AWS<br/>[ Example :: Single-Account ]

Deploy Deepfence cloud scanner for AWS in a single AWS account.<br/>
All the required resources and workloads will be run under the same account.

### Notice
**Deployment cost** - This example will create resources that cost money.<br/>Run `terraform destroy` when you don't need them anymore

## Usage
Copy the code below and paste it into a .tf file on your local machine.

```terraform

provider "aws" {
  # AWS region: Example: us-east-1
  region = "us-east-1"
}

module "deepfence-cloud-scanner_example_single-account" {
  source                        = "deepfence/cloud-scanner/aws//examples/single-account-ecs"
  version                       = "0.4.0"
  name                          = "deepfence-cloud-scanner"
  # mgmt-console-url: deepfence.customer.com or 22.33.44.55
  mgmt-console-url              = "<Console URL>"
  mgmt-console-port             = "443"
  deepfence-key                 = "<Deepfence key>"
  image                         = "quay.io/deepfenceio/cloud-scanner:2.1.0"
  # Task CPU Units (Default: 4 vCPU)
  cpu                           = "4096"
  # Task Memory (Default: 8 GB)
  memory                        = "8192"
  # Task Ephemeral Storage (Default: 100 GB)
  ephemeral_storage             = "100"
  # Task role: Must be either arn:aws:iam::aws:policy/SecurityAudit or arn:aws:iam::aws:policy/ReadOnlyAccess
  task_role                     = "arn:aws:iam::aws:policy/SecurityAudit"
  debug_logs                    = false
  # Use existing VPC (Optional)
  use_existing_vpc              = false
  # VPC ID (If use_existing_vpc is set to true)
  existing_vpc_id               = ""
  # List of VPC Subnet IDs (If use_existing_vpc is set to true)
  existing_vpc_subnet_ids       = []
  tags = {
    name = "deepfence-cloud-scanner"
  }
  # AWS region: Example: us-east-1
  region                        = "us-east-1"
  ecs_vpc_region_azs            = ["us-east-1a"]
}
```

To run this example you need have your [aws account profile configured in CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html) and to execute:
```bash
terraform init
terraform plan
terraform apply
```

## Requirements

| Name                                                                      | Version   |
|---------------------------------------------------------------------------|-----------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.15.0 |

## Providers

No providers.

## Modules

| Name                                                                  | Source                    | Version |
|-----------------------------------------------------------------------|---------------------------|---------|
| <a name="module_ecs-service"></a> [ecs-service](#module\_ecs-service) | ../../modules/ecs-service | n/a     |
| <a name="module_vpc-ecs"></a> [vpc-ecs](#module\_vpc-ecs)             | ../../modules/vpc-ecs     | n/a     |

## Resources

No resources.

## Inputs

| Name                                                                                           | Description                                                                                                                                                             | Type           | Default                                                     | Required |
|------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------|-------------------------------------------------------------|:--------:|
| <a name="input_ecs_vpc_region_azs"></a> [ecs\_vpc\_region\_azs](#input\_ecs\_vpc\_region\_azs) | List of Availability Zones for ECS VPC creation. e.g.: ["apne1-az1", "apne1-az2"]. If defaulted, two of the default 'aws\_availability\_zones' datasource will be taken | `list(string)` | <pre>[<br>  "us-east-1a"<br>]</pre>                         |    no    |
| <a name="input_name"></a> [name](#input\_name)                                                 | Prefix name for all resources                                                                                                                                           | `string`       | `"deepfence-cloud-scanner"`                                 |    no    |
| <a name="input_region"></a> [region](#input\_region)                                           | the AWS region in which resources are created, you must set the availability\_zones variable as well if you define this value to something other than the default       | `string`       | `"us-east-1"`                                               |    no    |
| <a name="input_tags"></a> [tags](#input\_tags)                                                 | Default tag for resource                                                                                                                                                | `map(string)`  | <pre>{<br>  "product": "deepfence-cloud-scanner"<br>}</pre> |    no    |

## Outputs

No outputs.
