data "aws_caller_identity" "current" {}

data "aws_caller_identity" "ops" {
    provider = aws.ops
}

data "terraform_remote_state" "connect_state" {
  backend = "s3"

  config = {
    bucket = "${data.aws_caller_identity.current.account_id}-${lower(var.service["code"])}-terraform-shared-state"
    key    = "${var.region}/${var.environment}/connect/terraform.tfstate"
    region = var.region
  }
}