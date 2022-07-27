# creates resource group

resource "aws_resourcegroups_group" "cloud_compliance_scanner" {

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