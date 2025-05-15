resource "aws_kinesis_firehose_delivery_stream" "agent_events" {
    name        = "${var.environment}${var.project}-agentevents"
    destination = "extended_s3"

    kinesis_source_configuration {
        kinesis_stream_arn = aws_kinesis_stream.agent_events.arn
        role_arn           = aws_iam_role.firehose.arn
    }

    extended_s3_configuration {
        role_arn   = aws_iam_role.firehose.arn
        bucket_arn = aws_s3_bucket.telephony.arn

        kms_key_arn = aws_kms_key.telephony.arn

        prefix     = "agentevents"
        error_output_prefix = "agentevents/error"


        # TODO - As part of a future bundle, implement processing
        #processing_configuration {
        #    enabled = "true"

        #    processors {
        #        type = "Lambda"

        #        parameters {
        #            parameter_name  = "LambdaArn"
        #            parameter_value = "${aws_lambda_function.stream.arn}:$LATEST"
        #        }
        #    }
        #}
    }
}


resource "aws_kinesis_firehose_delivery_stream" "ctr" {
    name        = "${var.environment}${var.project}-ctr"
    destination = "extended_s3"

    kinesis_source_configuration {
        kinesis_stream_arn = aws_kinesis_stream.ctr.arn
        role_arn           = aws_iam_role.firehose.arn
    }

    extended_s3_configuration {
        role_arn   = aws_iam_role.firehose.arn
        bucket_arn = aws_s3_bucket.telephony.arn

        kms_key_arn = aws_kms_key.telephony.arn

        prefix     = "CTR/"
        error_output_prefix = "CTRError"

        #processing_configuration {
        #    enabled = "true"

        #    processors {
        #        type = "Lambda"

        #        parameters {
        #            parameter_name  = "LambdaArn"
        #            parameter_value = "${aws_lambda_function.stream.arn}:$LATEST"
        #        }
        #    }
        #}
    }
}