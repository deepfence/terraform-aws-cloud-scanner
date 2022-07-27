# AWS Resource Group

## Requirements

| Name                                                                      | Version   |
|---------------------------------------------------------------------------|-----------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.15.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws)                   | >= 3.50.0 |

## Providers

| Name                                              | Version   |
|---------------------------------------------------|-----------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.50.0 |

## Modules

No modules.

## Resources

| Name                                                                                                                                                  | Type     |
|-------------------------------------------------------------------------------------------------------------------------------------------------------|----------|
| [aws_resourcegroups_group.deepfence_cloud_scanner](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/resourcegroups_group) | resource |

## Inputs

| Name                                           | Description                                                                                                                                                 | Type          | Default                                                     | Required |
|------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------|-------------------------------------------------------------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | Name to be assigned to all child resources. A suffix may be added internally when required. Use default value unless you need to install multiple instances | `string`      | `"deepfence-cloud-scanner"`                                 |    no    |
| <a name="input_tags"></a> [tags](#input\_tags) | Tag for resource group                                                                                                                                      | `map(string)` | <pre>{<br>  "product": "deepfence-cloud-scanner"<br>}</pre> |    no    |

## Outputs

No outputs.
