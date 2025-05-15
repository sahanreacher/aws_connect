data "aws_caller_identity" "current" {}

data "terraform_remote_state" "s3_state" {
  backend = "s3"

  config = {
    bucket = "${data.aws_caller_identity.current.account_id}-${lower(var.service["code"])}-terraform-shared-state"
    key    = "${var.region}/${var.environment}/s3_buckets/terraform.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "connect_state" {
  backend = "s3"

  config = {
    bucket = "${data.aws_caller_identity.current.account_id}-${lower(var.service["code"])}-terraform-shared-state"
    key    = "${var.region}/${var.environment}/connect/terraform.tfstate"
    region = var.region
  }
}