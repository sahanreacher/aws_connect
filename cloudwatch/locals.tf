locals {
  name_prefix     = "${var.env}${var.service["code"]}"
  name_prefix2    = "${var.env}${var.loc}${var.service["code"]}"
  shs_name_prefix = "shs${var.service["code"]}"
}

# TAGGING VARIABLES #
locals {
  required_tags = {
    Environment   = var.env
    Location      = var.location
    Project       = var.service["name"]
    Region        = var.region
    ServiceCode   = var.service["code"]
    ServiceName   = var.service["name"]
    ServiceType   = var.service["type"]
    Source        = "Terraform managed"
    TerraformRepo = "provision_fse_terraform"
  }
}
