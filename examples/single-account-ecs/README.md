# Deepfence cloud scanner in AWS<br/>[ Example :: Single-Account ] 

Deploy Deepfence cloud scanner for AWS in a single AWS account.<br/>
All the required resources and workloads will be run under the same account.

### Notice
**Deployment cost** - This example will create resources that cost money.<br/>Run `terraform destroy` when you don't need them anymore

## Usage
Copy the code below and paste it into a .tf file on your local machine.

```terraform

provider "aws" {
  region = "<AWS-REGION>; eg. us-east-1"
}

module "deepfence-cloud-scanner_example_single-account" {
  source                        = "deepfence/cloud-scanner/aws//examples/single-account-ecs"
  version                       = "0.1.4"
  mgmt-console-url              = "<Console URL> eg. XXX.XXX.XX.XXX"
  mgmt-console-port             = "443"
  deepfence-key                 = "<Deepfence-key> eg. XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
}
```
To run this example you need have your [aws account profile configured in CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html) and to execute:
```terraform
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
