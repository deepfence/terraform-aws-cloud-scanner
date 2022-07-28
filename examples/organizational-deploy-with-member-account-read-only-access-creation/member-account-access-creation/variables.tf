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
    "product" = "deepfence-cloud-scanner"
  }
}
