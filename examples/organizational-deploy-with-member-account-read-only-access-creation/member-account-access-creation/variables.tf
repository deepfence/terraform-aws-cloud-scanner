#---------------------------------
# optionals - with defaults
#---------------------------------

variable "name" {
  type        = string
  default     = "deepfence-cloud-scanner"
  description = "Name to be assigned to all child resources. A suffix may be added internally when required. Use default value unless you need to install multiple instances"
}

variable "tags" {
  type        = map(string)
  description = "Default tag for resource"
  default = {
    "product" = "cloud-compliance-scanner"
  }
}

variable "role_in_all_account_to_be_scanned" {
  type        = string
  default     = "deepfence-cloud-scanner-mem-acc-read-only-access"
  description = "read only role created in each member account"
}
