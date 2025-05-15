locals {
    #env="${terraform.workspace}"
    environment="${terraform.workspace}"
    

    envs = {
        "dev" = "dev"
        "tst" = "tst"
        "pre" = "pre"
        "prd" = "prd"
    }

    # Allowing us to capitalise the names properly
    #envs = {
    #    "dev" = "DEV"
    #    "tst" = "TST"
    #    "pre" = "PRE"
    #    "prd" = "PRD"
    #}


    private_subnet_counts = {
        "dev" = 2
        "tst" = 2
        "pre" = 2
        "prd" = 2
    }

    public_subnet_counts = {
        "dev" = 1
        "tst" = 1
        "pre" = 1
        "prd" = 1
    }

    vpc_cidr_blocks = {
        "dev" = "10.1.0.0/16"
        "tst" = "10.2.0.0/16"
        "pre" = "10.3.0.0/16"
        "prd" = "10.4.0.0/16"
    }

    env                  = "${lookup(local.envs,local.environment)}"
    private_subnet_count = "${lookup(local.private_subnet_counts,local.environment)}"
    public_subnet_count  = "${lookup(local.public_subnet_counts,local.environment)}"
    vpc_cidr_block       = "${lookup(local.vpc_cidr_blocks,local.environment)}"
}
