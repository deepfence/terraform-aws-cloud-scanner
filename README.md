# Cloud scanner for AWS by Deepfence

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

Please check out below to implement the same- <br>
[`./examples/single-account-ecs`](https://github.com/deepfence/terraform-aws-cloud-scanner/tree/main/examples/single-account-ecs)

### - Organizational

Deepfence workload will be deployed in a separate member account. A read only role in all other accounts will be assumed to perform scan in all the accounts
<br/>
Please check out below to implement the same- <br>
[`./examples/organizational`](https://github.com/deepfence/terraform-aws-cloud-scanner/tree/main/examples/organizational)

## Authors

Module is maintained and supported by [Deepfence](https://deepfence.io/).

## License

Apache 2 Licensed. See LICENSE for full details.
