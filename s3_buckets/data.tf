#
# COLLECT REMOTE STATE DATA #
#

# ACCOUNT ID
data "aws_caller_identity" "current" {}

data "aws_kms_key" "s3_kms" {
  key_id = "alias/${var.env}LDNFSES3KMS001"
}