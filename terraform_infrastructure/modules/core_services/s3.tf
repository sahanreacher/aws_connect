
resource "aws_s3_bucket" "telephony" {
    bucket = "${var.environment}inf-telephony"
    lifecycle {
        #prevent_destroy = true
        prevent_destroy = false
    }

    tags = {
        Description = "Call recording bucket"
        Environment = var.environment
        Name        = "${var.environment}inf-telephony"
        Product     = var.product
    }
}


resource "aws_s3_bucket_server_side_encryption_configuration" "telephony" {
    bucket = aws_s3_bucket.telephony.id

    rule {
        apply_server_side_encryption_by_default {
            kms_master_key_id = aws_kms_key.telephony.id
            sse_algorithm     = "aws:kms"
        }
    }
}



#data "aws_iam_policy_document" "enforce_encryption" {
#  statement {
#    principals {
#      type        = "AWS"
#      identifiers = ["123456789012"]
#    }
#
#    actions = [
#      "s3:GetObject",
#      "s3:ListBucket",
#    ]
#
#    resources = [
#      "${aws_s3_bucket.telephony.arn}",
#      "${aws_s3_bucket.telephony.arn}/*",
#    ]
#  }
#}

resource "aws_s3_bucket_policy" "enforce_encryption" {
    bucket = aws_s3_bucket.telephony.id
    policy = jsonencode({
        "Id": "ExamplePolicy",
        "Version": "2012-10-17",
        "Statement": [{
            "Sid": "AllowSSLRequestsOnly",
            "Action": "s3:*",
            "Effect": "Deny",
            "Resource": [
                "${aws_s3_bucket.telephony.arn}",
                "${aws_s3_bucket.telephony.arn}/*"
            ],
            "Condition": {
                "Bool": {
                    "aws:SecureTransport": "false"
                }
            },
            "Principal": "*"
        }]
    })
    #data.aws_iam_policy_document.enforce_encryption.json
}


