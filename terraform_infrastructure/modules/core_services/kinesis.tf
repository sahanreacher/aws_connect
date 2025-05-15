resource "aws_kinesis_stream" "agent_events" {
    name             = "${var.environment}${var.project}-kinesis-datastream-agentevents"

    encryption_type  = "KMS"
    kms_key_id       = aws_kms_key.kinesis.arn
    retention_period = var.retention_period

    shard_level_metrics = [
        "IncomingBytes",
        "OutgoingBytes",
    ]

    stream_mode_details {
        stream_mode = "ON_DEMAND"
    }

    tags = {
        Description = "Agent events stream"
        Environment = var.environment
        Name        = "${var.environment}${var.project}-kinesis-datastream-agentevents"
        Product     = var.product
    }
}


resource "aws_kinesis_stream" "ctr" {
    name             = "${var.environment}${var.project}-kinesis-datastream-ctr"

    encryption_type  = "KMS"
    kms_key_id       = aws_kms_key.kinesis.arn
    retention_period = var.retention_period

    shard_level_metrics = [
        "IncomingBytes",
        "OutgoingBytes",
    ]

    stream_mode_details {
        stream_mode = "ON_DEMAND"
    }

    tags = {
        Description = "Agent events stream"
        Environment = var.environment
        Name        = "${var.environment}${var.project}-kinesis-datastream-ctr"
        Product     = var.product
    }
}


resource "aws_connect_instance_storage_config" "ctr_streaming" {
    instance_id   = aws_connect_instance.instance.id
    resource_type = "CONTACT_TRACE_RECORDS"

    storage_config {
        kinesis_stream_config {
            stream_arn = aws_kinesis_stream.ctr.arn
        }
        storage_type = "KINESIS_STREAM"
    }
}


resource "aws_connect_instance_storage_config" "agent_events_streaming" {
    instance_id   = aws_connect_instance.instance.id
    resource_type = "AGENT_EVENTS"

    storage_config {
        kinesis_stream_config {
            stream_arn = aws_kinesis_stream.agent_events.arn
        }
        storage_type = "KINESIS_STREAM"
    }
}