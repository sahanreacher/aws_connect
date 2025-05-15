module "networking" {
    source               = "./modules/networking"

    environment          = "${local.env}"
    private_subnet_count = local.private_subnet_count
    public_subnet_count  = local.public_subnet_count
    vpc_cidr_block       = local.vpc_cidr_block

    region               = var.region
}
