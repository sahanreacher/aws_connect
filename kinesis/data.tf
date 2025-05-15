#############################
# COLLECT REMOTE STATE DATA #
#############################

## ACCOUNT ID
data "aws_caller_identity" "current" {
}

## GET KMS KEY STATE
data "terraform_remote_state" "kms_state" {
  backend = "s3"

  config = {
    bucket = "${data.aws_caller_identity.current.account_id}-${lower(var.service["code"])}-terraform-shared-state"
    key    = "${var.region}/${var.environment}/kms_keys/terraform.tfstate"
    region = var.region
  }
}

## GET S3 STATE
data "terraform_remote_state" "s3_state" {
  backend = "s3"

  config = {
    bucket = "${data.aws_caller_identity.current.account_id}-${lower(var.service["code"])}-terraform-shared-state"
    key    = "${var.region}/${var.environment}/s3_buckets/terraform.tfstate"
    region = var.region
  }
}

## GET IAM STATE
data "terraform_remote_state" "iam_state" {
  backend = "s3"

  config = {
    bucket = "${data.aws_caller_identity.current.account_id}-${lower(var.service["code"])}-terraform-shared-state"
    key    = "${var.region}/${var.environment}/iam/terraform.tfstate"
    region = var.region
  }
}

## GET S3 KMS KEY DATA
data "aws_kms_key" "s3_kms_key" {
  key_id = "alias/${var.env}${var.loc}${var.service["code"]}S3KMS001"
}