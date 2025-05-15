resource "aws_cloudwatch_log_group" "log_group_connect" {
  name              = "${local.name_prefix2}-connect-log-group"
  kms_key_id        = data.aws_kms_key.kms_key.arn
  retention_in_days = 60
  tags              = merge(tomap({ "Name" = "${local.name_prefix2}-connect-log-group" }), local.required_tags)
}