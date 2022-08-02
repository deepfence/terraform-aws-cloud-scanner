# Deepfence cloud scanner in AWS<br/>[ Example :: Organizational account setup ] - Deploy with member account read write access creation.

Deploy Deepfence cloud scanner for AWS in a Organizational setup with management and member account.<br/>

* In the **management account**
    * A role `deepfence-cloud-scanner-mgmt-acc-role` will be created
        * to be able to assumeRole and scan all member accounts.
        
* In the **user-provided member account**
    * All the Deepfence cloud scanner service-related resources/workload will be created

* In the **other member accounts**
    * A role will be assumed by `deepfence-cloud-scanner-mgmt-acc-role` in management account to scan resource in member account. 

### Notice
**Deployment cost** - This example will create resources that cost money.<br/>Run `terraform destroy` when you don't need them anymore

## Prerequisites

Minimum requirements:

1. Have an existing AWS account as the organization management account
    *  Within the Organization, following services must be enabled (Organization > Services)
        * [Organizational CloudFormation StackSets](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/stacksets-orgs-enable-trusted-access.html)
2. Configure [Terraform **AWS** Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs) for the `management` account of the organization

3. Organizational Multi-Account Setup, a specific role is required, to enable Deepfence cloud scanner to impersonate on organization member-accounts and provide

   * The ability to scan the resources in member account.
   * By default, it uses [AWS created default role `OrganizationAccountAccessRole`](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_accounts_access.html)
     * When an account is created within an organization, AWS will create an `OrganizationAccountAccessRole` [for account management](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_accounts_access.html), which Deepfence cloud scanner will use for scanning resources in member account.
     * However, when the account is invited into the organization, it's required to [create the role manually](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_accounts_access.html#orgs_manage_accounts_create-cross-account-role)
       > You have to do this manually, as shown in the following procedure. This essentially duplicates the role automatically set up for created accounts. We recommend that you use the same name, OrganizationAccountAccessRole, for your manually created roles for consistency and ease of remembering.
     * If role name, `OrganizationAccountAccessRole` wants to be modified, it must be done both on the `aws` member-account provider AND input value `organizational_member_default_admin_role`

5. Provide a member **account ID for Deepfence cloud scanner workload** to be deployed.
   Our recommendation is for this account to be empty, so that deployed resources are not mixed up with your workload.
   This input must be provided as terraform required input value
    ```
    CCS_member_account_id=<ORGANIZATIONAL_SECURE_FOR_CLOUD_ACCOUNT_ID>
    ```

## Role Summary

Role usage for this example comes as follows. 

- **management account**
    - terraform aws provider: default
    - `deepfence-cloud-scanner-mgmt-acc-role` will be created
        - used by Deepfence cloud scanner to `assumeRole` on `OrganizationAccountAccessRole` to be able to scan resources in member accounts.

- **member accounts**
    - terraform aws provider: 'member' aliased
        - this provider can be configured as desired, we just provide a default option
    - by default, we suggest using an assumeRole to the [AWS created default role `OrganizationAccountAccessRole`](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_accounts_access.html)
        - if this role does not exist provide input var `organizational_member_default_admin_role` with the role

- **Deepfence cloud scanner workload member account**
    - A role `deepfence-cloud-scanner-organizational-ECSTaskRole` will be used to define its permissions
        - used by Deepfence cloud scanner to assumeRole on management account `deepfence-cloud-scanner_mgmt-acc-role` and other organizations `OrganizationAccountAccessRole`

## Usage
Copy the code below and paste it into a .tf file on your local machine.

```terraform

provider "aws" {
  region = "<AWS-REGION>; eg. us-east-1"
}

provider "aws" {
  alias  = "member"
  region = "<AWS_REGION>; ex. us-east-1"
  assume_role {
    # 'OrganizationAccountAccessRole' is the default role created by AWS for managed-account users to be able to admin member accounts.
    # <br/>https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_accounts_access.html
    role_arn = "arn:aws:iam::${var.CCS_member_account_id}:role/OrganizationAccountAccessRole"
  }
}

module "deepfence-cloud-scanner_example_organizational" {
  providers = {
    aws.member = aws.member
  }
  source  = "deepfence/cloud-scanner/aws/examples/organizational"
  version = "0.1.0"
  CCS_member_account_id         = "<Member Account ID where Deepfence cloud scanner resources will be deployed> eg. XXXXXXXXXXXX"
  mode                          = "<Mode type> eg. service"
  mgmt-console-url              = "<Console URL> eg. XXX.XXX.XX.XXX"
  mgmt-console-port             = "<Console port> eg. 443"
  deepfence-key                 = "<Deepfence-key> eg. XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
  multiple-acc-ids              = "<all account ids where scanning will be done> ex. XXXXXXXXXXXX, XXXXXXXXXXXX, XXXXXXXXXXXX"
  org-acc-id                    = "<Organizational (Management) Account ID> ex. XXXXXXXXXXXX"
}

```

See [inputs summary](#inputs) or module [`variables.tf`](https://github.com/sysdiglabs/terraform-aws-secure-for-cloud/blob/master/examples/organizational/variables.tf) file for more optional configuration.

To run this example you need have your [aws management-account profile configured in CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html) and to execute:
```shell
terraform init
terraform plan
terraform apply
```


## Requirements

| Name                                                                      | Version   |
|---------------------------------------------------------------------------|-----------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.15.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws)                   | >= 4.0.0  |

## Providers

| Name                                                                   | Version |
|------------------------------------------------------------------------|---------|
| <a name="provider_aws.member"></a> [aws.member](#provider\_aws.member) | 4.17.1  |

## Modules

| Name                                                                                                                                                             | Source                                                | Version |
|------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------|---------|
| <a name="module_ecs-service"></a> [ecs-service](#module\_ecs-service)                                                                                            | ../../modules/services/ecs-service                    | n/a     |
| <a name="module_org-role-ecs"></a> [org-role-ecs](#module\_org-role-ecs)                                                                                         | ../../modules/infrastructure/permissions/org-role-ecs | n/a     |
| <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group)                                                                                 | ../../modules/infrastructure/resource-group           | n/a     |
| <a name="module_resource_group_secure_for_cloud_member"></a> [resource\_group\_secure\_for\_cloud\_member](#module\_resource\_group\_secure\_for\_cloud\_member) | ../../modules/infrastructure/resource-group           | n/a     |
| <a name="module_vpc-ecs"></a> [vpc-ecs](#module\_vpc-ecs)                                                                                                        | ../../modules/infrastructure/vpc-ecs                  | n/a     |

## Resources

| Name                                                                                                                                           | Type        |
|------------------------------------------------------------------------------------------------------------------------------------------------|-------------|
| [aws_iam_role.ccs_ecs_task_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role)                         | resource    |
| [aws_iam_policy_document.task_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name                                                                                                                                                               | Description                                                                                                                                                                                   | Type           | Default                                                     | Required |
|--------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------|-------------------------------------------------------------|:--------:|
| <a name="input_CCS_member_account_id"></a> [CCS\_member\_account\_id](#input\_CCS\_member\_account\_id)                                                            | Member Account ID where scanner resources will be deployed                                                                                                                                    | `string`       | `""`                                                        |    no    |
| <a name="input_ccs_ecs_task_role_name"></a> [ccs\_ecs\_task\_role\_name](#input\_ccs\_ecs\_task\_role\_name)                                                       | Name for the ecs task role. This is only required to resolve cyclic dependency with organizational approach                                                                                   | `string`       | `"organizational-ECSTaskRole"`                              |    no    |
| <a name="input_deepfence-key"></a> [deepfence-key](#input\_deepfence-key)                                                                                          | deepfence-key                                                                                                                                                                                 | `string`       | `""`                                                        |    no    |
| <a name="input_ecs_vpc_region_azs"></a> [ecs\_vpc\_region\_azs](#input\_ecs\_vpc\_region\_azs)                                                                     | List of Availability Zones for ECS VPC creation. e.g.: ["apne1-az1", "apne1-az2"]. If defaulted, two of the default 'aws\_availability\_zones' datasource will be taken                       | `list(string)` | `[]`                                                        |    no    |
| <a name="input_mgmt-console-port"></a> [mgmt-console-port](#input\_mgmt-console-port)                                                                              | mgmt-console-port                                                                                                                                                                             | `string`       | `"443"`                                                     |    no    |
| <a name="input_mgmt-console-url"></a> [mgmt-console-url](#input\_mgmt-console-url)                                                                                 | mgmt-console-url                                                                                                                                                                              | `string`       | `""`                                                        |    no    |
| <a name="input_mode"></a> [mode](#input\_mode)                                                                                                                     | mode                                                                                                                                                                                          | `string`       | `"service"`                                                 |    no    |
| <a name="input_name"></a> [name](#input\_name)                                                                                                                     | Prefix name for all resources                                                                                                                                                                 | `string`       | `"deepfence-cloud-scanner"`                                 |    no    |
| <a name="input_organizational_member_default_admin_role"></a> [organizational\_member\_default\_admin\_role](#input\_organizational\_member\_default\_admin\_role) | Default role created by AWS for management-account users to be able to admin member accounts.<br/>https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_accounts_access.html | `string`       | `"OrganizationAccountAccessRole"`                           |    no    |
| <a name="input_region"></a> [region](#input\_region)                                                                                                               | the AWS region in which resources are created, you must set the availability\_zones variable as well if you define this value to something other than the default                             | `string`       | `"us-east-1"`                                               |    no    |
| <a name="input_tags"></a> [tags](#input\_tags)                                                                                                                     | Default tag for resource                                                                                                                                                                      | `map(string)`  | <pre>{<br>  "product": "deepfence-cloud-scanner"<br>}</pre> |    no    |

## Outputs

No outputs.
