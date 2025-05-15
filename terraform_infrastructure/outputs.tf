output "connect_instance_id" {
    description = "Connect instance ID"
    value       = module.core_services.connect_instance_id
}


output "dynamic_config_lambda_arn" {
    description = "Dynamic Config Lambda ARN"
    value       = module.contact_flow.dynamic_config_lambda_arn
}


output "dynamic_config_lambda_name" {
    description = "Dynamic Config Lambda name"
    value       = module.contact_flow.dynamic_config_lambda_name
}


output "english_queue_id" {
    description = "English queue ID"
    value       = module.contact_flow.english_queue_id
}


output "english_queue_name" {
    description = "English queue name"
    value       = module.contact_flow.english_queue_name
}


output "operating_hours_id" {
    description = "Operating hours ID"
    value       = module.contact_flow.operating_hours_id
}


output "operating_hours_name" {
    description = "Operating hours name"
    value       = module.contact_flow.operating_hours_name
}


output "sequenceshift_queue_id" {
    description = "SequenceShift queue ID"
    value       = module.contact_flow.sequenceshift_queue_id
}


output "sequenceshift_queue_name" {
    description = "SequenceShift queue name"
    value       = module.contact_flow.sequenceshift_queue_name
}


output "welsh_queue_id" {
    description = "Welsh queue ID"
    value       = module.contact_flow.welsh_queue_id
}


output "welsh_queue_name" {
    description = "Welsh queue name"
    value       = module.contact_flow.welsh_queue_name
}
