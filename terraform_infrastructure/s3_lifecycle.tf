module "s3_lifecycle" {
    source                 = "./modules/s3_lifecycle"

    environment            = "${local.env}"
    s3_bucket_telephony_id = module.core_services.s3_bucket_telephony_id

    depends_on = [
        module.core_services
    ]
}
