module "contact_flow" {
    source                = "./modules/contact_flow"

    connect_instance_arn  = "${module.core_services.connect_instance_arn}"
    connect_instance_id   = "${module.core_services.connect_instance_id}"

    dynamic_config_subnet_ids = "${module.networking.private_cidr_blocks}"
    environment           = "${local.env}"

    vpc_id = "${module.networking.vpc_id}"
    vpc_cidr_block = "${local.vpc_cidr_block}"

    lambda_sg_id = "${module.networking.lambda_sg_id}"
}