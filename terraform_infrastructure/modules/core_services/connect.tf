resource "aws_connect_instance" "instance" {
    early_media_enabled            = true
    identity_management_type       = "SAML"
    inbound_calls_enabled          = true
    instance_alias                 = "${var.environment}${var.project}-connect"
    multi_party_conference_enabled = true
    outbound_calls_enabled         = true

    contact_flow_logs_enabled      = true

    tags = {
        Name        = "${var.environment}${var.project}-connect"

        Decription  = "Telephony instance"
        Environment = var.environment
        Product     = var.product
    }
}


resource "aws_connect_instance_storage_config" "call_recordings" {
    instance_id   = aws_connect_instance.instance.id
    resource_type = "CALL_RECORDINGS"

    storage_config {
        storage_type = "S3"

        s3_config {
            bucket_name   = aws_s3_bucket.telephony.id
            bucket_prefix = "CallRecordings"

            encryption_config {
                encryption_type = "KMS"
                key_id          = aws_kms_key.telephony.arn
            }
        } 
    }
}


resource "aws_connect_instance_storage_config" "reports" {
    instance_id   = aws_connect_instance.instance.id
    resource_type = "SCHEDULED_REPORTS"

    storage_config {
        storage_type = "S3"

        s3_config {
            bucket_name   = aws_s3_bucket.telephony.id
            bucket_prefix = "Reports"

            encryption_config {
                encryption_type = "KMS"
                key_id          = aws_kms_key.telephony.arn
            }
        } 
    }
}
