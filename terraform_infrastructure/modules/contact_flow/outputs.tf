output "dynamic_config_lambda_arn" {
    description = "Dynamic Config Lambda ARN"
    value       = aws_lambda_function.dynamic_config.arn
}


output "dynamic_config_lambda_name" {
    description = "Dynamic Config Lambda name"
    value       = aws_lambda_function.dynamic_config.function_name
}


output "english_queue_id" {
    description = "English queue ID"
    value       = aws_connect_queue.english.queue_id
}


output "english_queue_name" {
    description = "English queue name"
    value       = aws_connect_queue.english.name
}


output "operating_hours_id" {
    description = "Operating hours ID"
    value       = aws_connect_hours_of_operation.hoo.arn
}


output "operating_hours_name" {
    description = "Operating hours name"
    value       = aws_connect_hours_of_operation.hoo.name
}


output "sequenceshift_queue_id" {
    description = "SequenceShift queue ID"
    value       = aws_connect_queue.sequenceshift.queue_id
}


output "sequenceshift_queue_name" {
    description = "SequenceShift queue name"
    value       = aws_connect_queue.sequenceshift.name
}


output "welsh_queue_id" {
    description = "Welsh queue ID"
    value       = aws_connect_queue.welsh.queue_id
}


output "welsh_queue_name" {
    description = "Welsh queue name"
    value       = aws_connect_queue.welsh.name
}
