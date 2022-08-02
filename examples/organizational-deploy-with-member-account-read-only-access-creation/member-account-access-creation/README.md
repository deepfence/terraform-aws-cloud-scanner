# Member accounts access creation

This folder contains steps and files to create a read only role in multiple member accounts and a task role for ECS in a single member account. The read only role created will be used by Deepfence cloud scanner to scan member accounts and ECS task role will be mapped to these roles. The access in each member account is created by a management account which has access to assume admin role in all member accounts to create access resources.

`Jinja2`, `Doit` is used to automate creation of Terraform files. While `Bash script` is used to do end-to-end automation of steps.

The Terraform files created through this automation for each member account includes-
1. **Provider block** to assume role in member account.
2. Creation of a role named- **'deepfence-cloud-scanner-mem-acc-read-only-access'**.
3. Creation of a role named- **'deepfence-cloud-scanner-organizational-ECSTaskRole'**.
4. Creation of **trust policy** for the read only role to be assumed by member account where Deepfence cloud scanner will be deployed.
5. Attachment of **AWS managed policy**- read only access to role.
6. Creation of **assume policy** for ECS task role to assume read only roles in all accounts and **trust policy** for role to be assumed by ECS task. 

## Prerequisites

The terraform files created through Jinja template will use a management account to assume role in member account to create access in member accounts.

Minimum requirements:
1. In each Member account, there should be trust policy for -[`OrganizationAccountAccessRole`](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_accounts_access.html) role to be accessed by management account. Also, assume policy should be there in management account to assume role in member accounts.

     * When a member account is created within an organization, AWS will create an `OrganizationAccountAccessRole` [for account management](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_accounts_access.html) in member account. 
     * However, when the account is invited into the organization, it's required to [create the role manually](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_accounts_access.html#orgs_manage_accounts_create-cross-account-role)
       > You have to do this manually, as shown in the following procedure. This essentially duplicates the role automatically set up for created accounts. We recommend that you use the same name, OrganizationAccountAccessRole, for your manually created roles as same will be mentioned in terraform script generated through Jinja template.

2. [Pip](https://pip.pypa.io/en/stable/installation/) package installer needs to be installed.

## Usage

Follow below steps to create the access in member account.

1. Create a folder in your local system. Create a file - account_details.txt and add the required data in below format and save it. Mentioned below is sample data. <br><br>
   ```
   account_details_block_A = [
    {'alias': 'MEMBER1', 'region': 'us-east-1', 'member_account_id': '000000000000', 'ccs_mem_account_id': '000000000000'},
    {'alias': 'MEMBER2', 'region': 'us-east-2', 'member_account_id': '000000000000', 'ccs_mem_account_id': '000000000000'}]

   account_details_block_B = [
    {'alias': 'MEMBER3', 'region': 'us-east-1', 'ccs_mem_account_id': '000000000000'}]

    ```
   
   **account_details_block_A** <br>
   This data block should have details for member id accounts where read only access needs to be created.<br>
   `Alias`- Alias is required for provider block in Terraform. For each member account alias should be unique.<br>
   `region`- Enter region for member account where access needs to be created.<br>
   `member_account_id`- Enter member account id to assume access in member account. This is the member account id where access will be created.<br>
   `ccs_mem_account_id` - Member account id where Deepfence cloud scanner resources are deployed. This will be used to set trust policy to access role in member accounts.<br>

   **account_details_block_B** <br>
   This data block should have details for member id account where Deepfence cloud scanner will be deployed with ecs task.<br>
    `Alias`- Alias is required for provider block in Terraform. <br>
   `region`- Enter region for member account where access needs to be created.<br>
   `ccs_mem_account_id`- Enter member account id to assume access in member account. This is the member account id where access will be created for ecs task.<br>

2. Download [this](https://github.com/deepfence/terraform-aws-cloud-scanner/blob/main/examples/organizational-deploy-with-member-account-read-only-access-creation/member-account-access-creation/startup) bash script in the same folder, run it to **automate** the creation of Terraform files, running of Terraform scripts to create access. <br><br>
   ```shell
   chmod +x startup.sh
   ./startup.sh
   ```

   Please note you can add more member accounts under **account_details_1** in **account_details.txt** and rerun bash script to create access for new member accounts. However if you wish to delete role in a member account, you need to manually modify the Terraform script and do an apply. Similarly you need to do a **Terraform destroy** to destroy the roles in all member accounts.

3. Once the access is created you may follow [this](https://registry.terraform.io/modules/deepfence/cloud-scanner/aws/0.1.2/examples/organizational-deploy-with-member-account-read-only-access-creation) link to deploy Deepfence cloud scanner.

