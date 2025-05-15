####################
# OUTPUT VARIABLES #
####################

output "kinesis_role_arn" {
  value = aws_iam_role.firehose_service_role.arn
}


