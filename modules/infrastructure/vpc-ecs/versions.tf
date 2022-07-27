# sets version requirement for VPC resource creation

terraform {
  required_version = ">= 0.15.0"
  required_providers {
    aws = {
      version = ">= 3.50.0"
    }
  }
}
