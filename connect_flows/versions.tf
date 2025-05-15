terraform {
  backend "s3" {}
  required_version = "=1.5.5"
  required_providers {
    aws = {
      version = "~>5.8"
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
