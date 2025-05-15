locals {
  name_prefix     = "${var.env}${var.service["code"]}"
  name_prefix2    = "${var.env}${var.loc}${var.service["code"]}"
  shs_name_prefix = "shs${var.service["code"]}"
}

# TAGGING VARIABLES #
locals {
  required_tags = {
    Environment   = var.env
    GRP           = "${local.name_prefix2}ALL"
    Location      = var.location
    Project       = var.service["name"]
    Region        = var.region
    ServiceCode   = var.service["code"]
    ServiceName   = var.service["name"]
    ServiceType   = var.service["type"]
    Source        = "Terraform managed"
    TerraformRepo = "provision_account_vpcs_terraform"
  }

  required_tags_ireland = {
    Environment   = var.env
    GRP           = "${local.name_prefix2}ALL"
    Location      = "Ireland"
    Project       = var.service["name"]
    Region        = "eu-west-1"
    ServiceCode   = var.service["code"]
    ServiceName   = var.service["name"]
    ServiceType   = var.service["type"]
    Source        = "Terraform managed"
    TerraformRepo = "provision_account_vpcs_terraform"
  }

  resource_ref = {
    fes = "FES"
    bes = "BES"
  }

  resource_prefix = {
    fes = "${local.name_prefix}${local.resource_ref["fes"]}"
    bes = "${local.name_prefix}${local.resource_ref["bes"]}"
  }

  required_tags_fes = {
    Tier = local.resource_ref["fes"]
  }

  required_tags_bes = {
    Tier = local.resource_ref["bes"]
  }
}
