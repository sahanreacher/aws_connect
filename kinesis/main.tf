#######################
# KINESIS DATASTREAMS #
#######################

## Kinesis Datastream - Controller
resource "aws_kinesis_stream" "kinesis_datastream_ctr_001" {
  name             = "${lower(local.name_prefix)}-kinesis-datastream-ctr-001"
  retention_period = 24 # 1 hour retention period

  stream_mode_details {
    stream_mode = "ON_DEMAND"
  }

  encryption_type = "KMS"
  kms_key_id      = data.terraform_remote_state.kms_state.outputs.kms_kin_key_id
  tags            = local.required_tags
}

## Kinesis Datastream - Agent Events 
resource "aws_kinesis_stream" "kinesis_datastream_agentevents_001" {
  name             = "${lower(local.name_prefix)}-kinesis-datastream-agentevents-001"
  retention_period = 24 # 1 hour retention period

  stream_mode_details {
    stream_mode = "ON_DEMAND"
  }

  encryption_type = "KMS"
  kms_key_id      = data.terraform_remote_state.kms_state.outputs.kms_kin_key_id
  tags            = local.required_tags
}

####################
# KINESIS FIREHOSE #
####################


# Firehose Stream for CTR
resource "aws_kinesis_firehose_delivery_stream" "kinesis_stream_ctr_001" {
  name        = "${lower(local.name_prefix)}-kinesis-stream-ctr-001"
  destination = "extended_s3"

  kinesis_source_configuration {
    kinesis_stream_arn = aws_kinesis_stream.kinesis_datastream_ctr_001.arn
    role_arn           = data.terraform_remote_state.iam_state.outputs.kinesis_role_arn

  }

  extended_s3_configuration {
    role_arn            = data.terraform_remote_state.iam_state.outputs.kinesis_role_arn
    bucket_arn          = data.terraform_remote_state.s3_state.outputs.con_bucket_arn
    prefix              = "CTR/"
    error_output_prefix = "CTRError/"
    buffering_interval  = 300
    buffering_size      = 5
  }
  tags = local.required_tags
}

# Kinesis Firehose for Agent Events
resource "aws_kinesis_firehose_delivery_stream" "kinesis_stream_agentevents_001" {
  name        = "${lower(local.name_prefix)}-firehose-stream-agentevents-001"
  destination = "extended_s3"

  kinesis_source_configuration {
    kinesis_stream_arn = aws_kinesis_stream.kinesis_datastream_agentevents_001.arn
    role_arn           = data.terraform_remote_state.iam_state.outputs.kinesis_role_arn

  }

  extended_s3_configuration {
    role_arn            = data.terraform_remote_state.iam_state.outputs.kinesis_role_arn
    bucket_arn          = data.terraform_remote_state.s3_state.outputs.con_bucket_arn
    prefix              = "agentevents/"
    error_output_prefix = "agentevents/error/"
    buffering_interval  = 300
    buffering_size      = 5
  }
  tags = local.required_tags
}