# Deepfence cloud scanner in AWS<br/>[ Example :: Organizational account setup ] - Deploy with member-account read-only access creation.

Deploy Deepfence cloud scanner for AWS in a Organizational setup. This approach involves deploying Deepfence cloud scanner in a single member account and creating a read only access role in all other member accounts for scanning. Jinja template, doit and bash script is used to automate creation of Terraform files for access creation in all member accounts. <br/>

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

2. [Pip](https://pip.pypa.io/en/stable/installation/) package installer needs to be installed for installing required dependencies.

## Usage

1. Create a folder in your local system. Create a file - account_details.txt and add the required data in below format and save it. Mentioned        below is sample data. This file will be used to create read only role in each member account mentioned as `member_account_id` <br/>
   ```
   account_details = [
    {'alias': 'MEMBER1', 'region': 'us-east-1', 'member_account_id': '000000000000', 'ccs_mem_account_id': '000000000000'},
    {'alias': 'MEMBER2', 'region': 'us-east-2', 'member_account_id': '000000000000', 'ccs_mem_account_id': '000000000000'}]
   ```
   `Alias`- Alias is required for provider block in Terraform. For each member account alias should be unique. <br/>
   `region`- Enter region for member account where access needs to be created. <br/>
   `member_account_id`- Enter member account id to assume access in member account. This is the member account id where access will be created.<br/>
   `ccs_mem_account_id` - Member account id where Deepfence cloud scanner resources are deployed. This will be used to set trust policy to access     role in member accounts. <br/>

2. Copy the snippet below and paste it into a main.tf file in same folder on your local machine, fill in the required details to import registry    module to deploy scanner in a single member account.

   ```terraform
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
   version                       = "0.1.3"
   CCS_member_account_id         = "${local.CCS_member_account_id}"
   mode                          = "service"
   mgmt-console-url              = "XXX.XXX.XX.XXX"
   mgmt-console-port             = "443"
   deepfence-key                 = "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
   multiple-acc-ids              = "<Member account ids where scanning will be done> ex. XXXXXXXXXXXX, XXXXXXXXXXXX, XXXXXXXXXXXX"
   org-acc-id                    = "<Management account id> ex. XXXXXXXXXXXX"
   }
   ```
3. Download [this](https://github.com/deepfence/terraform-aws-cloud-scanner/blob/aws-alt-fix-cyclic-dep/examples/organizational-deploy-with-        member-account-read-only-access-creation/startup.sh) bash script in the same folder, run it to **automate** the creation of Terraform files to    create read only role in each member account. <br/><br/>
   ```shell
   chmod +x startup
   ./startup
   ```

   Please note you can add more member accounts in **account_details.txt** and rerun bash script to create access for new member accounts.          However if you wish to delete role in a member account, you need to manually modify the Terraform script and do an **Terraform apply**.          Similarly you need to do a **Terraform destroy** to destroy the roles in all member accounts.

4. Run Terraform commands to create the resources. To run this example you need have your [aws management-account profile configured in CLI]        (https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html) and to execute:
   ```terraform
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
