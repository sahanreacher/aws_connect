data "aws_caller_identity" "current" {}

data "terraform_remote_state" "s3_state" {
  backend = "s3"

  config = {
    bucket = "${data.aws_caller_identity.current.account_id}-${lower(var.service["code"])}-terraform-shared-state"
    key    = "${var.region}/${var.environment}/s3_buckets/terraform.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "kinesis_state" {
  backend = "s3"

  config = {
    bucket = "${data.aws_caller_identity.current.account_id}-${lower(var.service["code"])}-terraform-shared-state"
    key    = "${var.region}/${var.environment}/kinesis/terraform.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "kms_state" {
  backend = "s3"

  config = {
    bucket = "${data.aws_caller_identity.current.account_id}-${lower(var.service["code"])}-terraform-shared-state"
    key    = "${var.region}/${var.environment}/kms_keys/terraform.tfstate"
    region = var.region
  }
}

data "aws_kms_key" "s3_key" {
  key_id = "alias/${var.env}LDNFSES3KMS001"
}

data "aws_kms_key" "connect_key" {
  key_id = "alias/${var.env}LDNFSECONKMS001"
}

#UNSUPPORTED BY HASHICORP AWS BELOW

# data "aws_polly_voices" "example" {
#   language_code = "en-GB"
# }