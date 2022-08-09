# Cloud Scanner for AWS by Deepfence

This module deploys Deepfence cloud scanner for AWS by creating underlying resources in AWS.

### Notice

* **Deployment cost** This example will create resources that cost money.<br/>Run `terraform destroy` when you don't need them anymore

## Required Permissions

### Provisioning Permissions

User deploying the resources needs the below access on AWS-
- ECS 
- VPC 
- CloudWatch
- IAM

## Usage

### - Single-Account on ECS

Deepfence workload will be deployed in the same account where user's resources will be watched.

Please check out below to implement the same:

[`./examples/single-account-ecs`](https://github.com/deepfence/terraform-aws-cloud-scanner/tree/main/examples/single-account-ecs)

### - Organizational

Deepfence workload will be deployed in a separate member account while scanning will be done in multiple member accounts. 

Following is the method to deploy the same: 


- [`./examples/organizational-deploy-with-member-account-read-only-access-creation`](https://github.com/deepfence/terraform-aws-cloud-scanner/tree/main/examples/organizational-deploy-with-member-account-read-only-access-creation)


## Authors

Module is maintained and supported by [Deepfence](https://deepfence.io/).

## License

Apache 2 Licensed. See LICENSE for full details.
