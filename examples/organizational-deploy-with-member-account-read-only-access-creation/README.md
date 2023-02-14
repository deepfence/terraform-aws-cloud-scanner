# Deepfence Cloud Scanner in AWS<br/>[ Example :: Organizational account setup ] - Deploy with member-account read-only access creation.

Deploy Deepfence cloud scanner for AWS in an Organizational setup. This approach involves deploying Deepfence cloud scanner in a single member account and creating a read only access role in all other member accounts for scanning. Jinja template, doit and bash script is used to automate creation of Terraform files for access creation in all member accounts. <br/>

Setup is as follows-
* In the **user-provided member account**
    * All the Deepfence cloud scanner service related resources/workload will be created

* In the **other member accounts**
    * A role will be created which will be assumed to perform scan.
     
### Notice
**Deployment cost** - This example will create resources that cost money.<br/>Run `terraform destroy` when you don't need them anymore

## Prerequisites

Minimum requirements:
1. Management account will be used to assume access in required member account for access creation and scanner deployment in container. In each Member account, there should be trust policy for -[`OrganizationAccountAccessRole`](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_accounts_access.html) role to be accessed by management account. Also, assume policy should be there in management account to assume role in member accounts.

     * When a member account is created within an organization, AWS will create an `OrganizationAccountAccessRole` [for account management](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_accounts_access.html) in member account. 
     * However, when the account is invited into the organization, it's required to [create the role manually](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_accounts_access.html#orgs_manage_accounts_create-cross-account-role)
       > You have to do this manually, as shown in the following procedure. This essentially duplicates the role automatically set up for created accounts. We recommend that you use the same name, OrganizationAccountAccessRole, for your manually created roles as same will be used to assume role in all member accounts.

## Usage

1. Create a folder in your local system. Download organizational deployment helper from the latest release.
```bash
# https://github.com/deepfence/terraform-aws-cloud-scanner/releases/latest
wget "https://github.com/deepfence/terraform-aws-cloud-scanner/releases/download/v0.3.0/organization_deployment_helper-v0.3.0-linux-amd64.tar.gz"
tar -xzf organization_deployment_helper-v0.3.0-linux-amd64.tar.gz
chmod +x organization_deployment_helper

wget "https://raw.githubusercontent.com/deepfence/terraform-aws-cloud-scanner/v0.3.0/examples/organizational-deploy-with-member-account-read-only-access-creation/member-account-access-creation-files/readonlyaccess.tf.j2"
wget "https://raw.githubusercontent.com/deepfence/terraform-aws-cloud-scanner/v0.3.0/examples/organizational-deploy-with-member-account-read-only-access-creation/member-account-access-creation-files/main.tf.j2"

# Ensure awscli is installed and organization account is configured 
./organization_deployment_helper
```

2. This will generate a main.tf terraform file with the following content.

```terraform
variable "name" {
  type        = string
  default     = "deepfence-cloud-scanner"
  description = "Name to be assigned to all child resources. A suffix may be added internally when required. Use default value unless you need to install multiple instances"
}

variable "tags" {
  type        = map(string)
  description = "Default tag for resource"
  default = {
    "product" = "deepfence-cloud-scanner"
  }
}

locals{
   CCS_member_account_id="<Member Account ID where Deepfence cloud scanner resources will be deployed> eg. XXXXXXXXXXXX"
}

provider "aws" {
   alias  = "member"
   region = "us-east-1"
   assume_role {
   # 'OrganizationAccountAccessRole' is the default role created by AWS for managed-account users to be able to admin member accounts.
   # <br/>https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_accounts_access.html
    role_arn = "arn:aws:iam::${local.CCS_member_account_id}:role/OrganizationAccountAccessRole"
   }
}

module "cloud-scanner_example_organizational-deploy-with-member-account-read-only-access-creation" {
   providers = {
    aws.member = aws.member
   }
   source                        = "deepfence/cloud-scanner/aws//examples/organizational-deploy-with-member-account-read-only-access-creation"
   version                       = "0.1.0"
   CCS_member_account_id         = "${local.CCS_member_account_id}"
   name                          = var.name
   tags                          = var.tags
   mgmt-console-url              = "<Console URL> eg. XXX.XXX.XX.XXX"
   mgmt-console-port             = "443"
   deepfence-key                 = "<Deepfence-key> eg. XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
   image                         = "deepfenceio/cloud-scanner:latest"
   multiple-acc-ids              = "<Member account ids where scanning will be done> ex. XXXXXXXXXXXX, XXXXXXXXXXXX, XXXXXXXXXXXX"
}
```

3. This Terraform module creates read only role in each member account and deploys deepfence-cloud-scanner ECS task in one of the selected member account.       

4. Run Terraform commands to create the resources. To run this example you need have your [aws management-account profile configured in CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html) and to execute:
```bash
terraform init
terraform plan
terraform apply
```

See inputs summary for more optional configuration.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.15.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws.member"></a> [aws.member](#provider\_aws.member) | 4.24.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ecs-service"></a> [ecs-service](#module\_ecs-service) | ../../modules/services/ecs-service | n/a |
| <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group) | ../../modules/infrastructure/resource-group | n/a |
| <a name="module_vpc-ecs"></a> [vpc-ecs](#module\_vpc-ecs) | ../../modules/infrastructure/vpc-ecs | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.ccs_ecs_task_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.mem_acc_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_policy_document.mem_acc_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.task_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_CCS_member_account_id"></a> [CCS\_member\_account\_id](#input\_CCS\_member\_account\_id) | Member Account ID where scanner resources will be deployed | `string` | `""` | no |
| <a name="input_ccs_ecs_task_role_name"></a> [ccs\_ecs\_task\_role\_name](#input\_ccs\_ecs\_task\_role\_name) | Name for the ecs task role. This is only required to resolve cyclic dependency with organizational approach | `string` | `"organizational-ECSTaskRole"` | no |
| <a name="input_deepfence-key"></a> [deepfence-key](#input\_deepfence-key) | deepfence-key | `string` | `""` | no |
| <a name="input_ecs_vpc_region_azs"></a> [ecs\_vpc\_region\_azs](#input\_ecs\_vpc\_region\_azs) | List of Availability Zones for ECS VPC creation. e.g.: ["apne1-az1", "apne1-az2"]. If defaulted, two of the default 'aws\_availability\_zones' datasource will be taken | `list(string)` | `[]` | no |
| <a name="input_mem_acc_ecs_task_role_name"></a> [mem\_acc\_ecs\_task\_role\_name](#input\_mem\_acc\_ecs\_task\_role\_name) | Name for the ecs task role. This is only required to resolve cyclic dependency with organizational approach | `string` | `""` | no |
| <a name="input_mgmt-console-port"></a> [mgmt-console-port](#input\_mgmt-console-port) | mgmt-console-port | `string` | `"443"` | no |
| <a name="input_mgmt-console-url"></a> [mgmt-console-url](#input\_mgmt-console-url) | mgmt-console-url | `string` | `""` | no |
| <a name="input_mode"></a> [mode](#input\_mode) | mode | `string` | `"service"` | no |
| <a name="input_multiple-acc-ids"></a> [multiple-acc-ids](#input\_multiple-acc-ids) | These account ids are those where scanning will be done | `string` | `""` | no |
| <a name="input_name"></a> [name](#input\_name) | Prefix name for all resources | `string` | `"deepfence-cloud-scanner"` | no |
| <a name="input_org-acc-id"></a> [org-acc-id](#input\_org-acc-id) | This account id is the management account id which is there in an organizational setup | `string` | `""` | no |
| <a name="input_region"></a> [region](#input\_region) | the AWS region in which resources are created, you must set the availability\_zones variable as well if you define this value to something other than the default | `string` | `"us-east-1"` | no |
| <a name="input_role_in_all_account_to_be_scanned"></a> [role\_in\_all\_account\_to\_be\_scanned](#input\_role\_in\_all\_account\_to\_be\_scanned) | Default role created by AWS for management-account users to be able to admin member accounts.<br/>https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_accounts_access.html | `string` | `"deepfence-cloud-scanner-mem-acc-read-only-access"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Default tag for resource | `map(string)` | <pre>{<br>  "product": "deepfence-cloud-scanner"<br>}</pre> | no |

## Outputs

No outputs.
