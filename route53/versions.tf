terraform {
  backend "s3" {}
  required_version = "=1.5.5"
  required_providers {
    aws = {
      version = ">= 5.0, <= 5.13.1"
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = var.region
  default_tags {
    tags = local.required_tags
  }
}

provider "aws" {
  region = var.region
  alias  = "ops"

  assume_role {
    role_arn     = "arn:aws:iam::147854442242:role/OpsSharedServicesAdmin"
    session_name = "terraform-ops-profile"
    external_id  = "terraform-ops-profile"
  }
  default_tags {
    tags = local.required_tags
  }
}