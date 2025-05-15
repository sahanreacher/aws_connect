module "core_services" {
    source                     = "./modules/core_services"

    environment                = "${local.env}"
}