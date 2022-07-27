# creates resource group

resource "aws_resourcegroups_group" "deepfence_cloud_scanner" {

  name = "${var.name}-resource-group"
  tags = var.tags

  resource_query {
    query = <<JSON
{
  "ResourceTypeFilters": [
    "AWS::AllSupported"
  ],
  "TagFilters": [
    {
      "Key": "product",
      "Values": ["${var.tags["product"]}"]
    }
  ]
}
JSON
  }
}