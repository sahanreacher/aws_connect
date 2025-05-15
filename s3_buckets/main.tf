module "s3_bucket_con" {
  source = "terraform-aws-modules/s3-bucket/aws"
  version = "3.15.2"

  bucket = "${lower(local.name_prefix2)}cons3bkt"

  versioning = {
    enabled = true
  }

  restrict_public_buckets = true
  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "aws:kms"
        kms_master_key_id = data.aws_kms_key.s3_kms.id
      }
    }
  }
  tags = merge(
    {
      
      "Name"  = "${lower(local.name_prefix2)}cons3bkt",
      "Product" = "DEFRA Connect Platform"
      "Description" = "Bucket for telephony"
      "Environment" = lower(var.env)
    },
  local.required_tags)
}
