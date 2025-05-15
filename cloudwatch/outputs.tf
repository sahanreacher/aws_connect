
output "log_group_connect_name" {
  value       = aws_cloudwatch_log_group.log_group_connect.name
  description = "The name of the connect log group"
}
output "log_group_connect_arn" {
  value       = aws_cloudwatch_log_group.log_group_connect.arn
  description = "The arn of the connect log group"
}
