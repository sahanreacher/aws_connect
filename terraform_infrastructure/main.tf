terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 5.0"
        }
    }

    required_version = ">= 1.2.0"
}


provider "aws" {
    region = var.region
}


terraform {
    backend "s3" {
        bucket       = "defra-terraform"
        key          = "infrastructure/state.tfstate"
        region       = "eu-west-2"
    }
}
