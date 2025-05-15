##################################################
# TERRAFORM OUTPUTS TO BE STORED IN REMOTE STATE #
##################################################
output "kinesis_datastream_ctr_arn" {
  value = aws_kinesis_stream.kinesis_datastream_ctr_001.arn
}

output "kinesis_datastream_agentevents_arn" {
  value = aws_kinesis_stream.kinesis_datastream_agentevents_001.arn
}

output "kinesis_stream_ctr_arn" {
  value = aws_kinesis_firehose_delivery_stream.kinesis_stream_ctr_001.arn
}

output "kinesis_stream_agentevents_arn" {
  value = aws_kinesis_firehose_delivery_stream.kinesis_stream_agentevents_001.arn
}



