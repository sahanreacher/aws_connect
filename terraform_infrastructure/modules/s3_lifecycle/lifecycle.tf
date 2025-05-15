resource "aws_s3_bucket_lifecycle_configuration" "storage_class_expiry" {
    bucket = var.s3_bucket_telephony_id

    rule {
        id = "${var.environment}${var.project}-telephony_lifecycle"

        filter {
            prefix = ""
        }

        transition {
            days          = 30
            storage_class = "STANDARD_IA"
        }

        expiration {
            days = 90
        }

        noncurrent_version_expiration {
            noncurrent_days = 30
        }

        abort_incomplete_multipart_upload {
            days_after_initiation = 90
        }

        status = "Enabled"
    }
}
