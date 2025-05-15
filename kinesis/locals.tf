######################
# Set local variables
######################

locals {
  name_prefix = "${var.env}${var.loc}${var.service["code"]}"
}

## TAGGING VARIABLES ##
locals {
  required_tags = {
    Environment = var.env
    Project     = var.service["name"]
    Region      = var.region
    ServiceCode = var.service["code"]
    ServiceName = var.service["name"]
    ServiceType = var.service["type"]
    Source      = "Terraform managed"
  }
}