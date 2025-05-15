
#resource "aws_kms_key" "s3" {
#    description              = "A key for Call Recordings in S3"
#
#    customer_master_key_spec = "SYMMETRIC_DEFAULT"
#    deletion_window_in_days  = 30
#    enable_key_rotation      = false
#    key_usage                = "ENCRYPT_DECRYPT"
#    multi_region             = "false"
#
#    tags = {
#        Description = "Call recording key"
#        Environment = var.environment
#        Name        = "${var.environment}inf-telephony"
#        Product     = "Defra Connect Platform"
#    }
#}


#resource "aws_kms_key_policy" "s3" {
#    key_id = aws_kms_key.s3.id
#    policy = jsonencode({
#        Version = "2012-10-17"
#        Id      = "key-kinesis"
#        Statement = [{
#            Sid    = "Enable IAM User Permissions"
#            Effect = "Allow"
#            Principal = {
#                AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
#            },
#            Action   = "kms:*"
#            Resource = "*"
#        }]
#    })
#}


resource "aws_kms_key" "telephony" {
    description              = "A key for Call Recordings in S3"

    customer_master_key_spec = "SYMMETRIC_DEFAULT"
    deletion_window_in_days  = 30
    enable_key_rotation      = false
    key_usage                = "ENCRYPT_DECRYPT"
    multi_region             = "false"

    tags = {
        Description = "Key to encrypt Connect resources"
        Environment = var.environment
        Name        = "${var.environment}${var.project}-kms-key-connecttelephony"
        Product     = var.product
    }
}






# TODO - Do we need this? Does anything reference?
# Seems to be an S3 key, with a misleading name? Can the name be changed?
resource "aws_kms_key_policy" "telephony" {
    key_id = aws_kms_key.telephony.id
    policy = jsonencode({
        Version = "2012-10-17"
        Id      = "key-kinesis"
        Statement = [{
            Sid    = "Enable IAM User Permissions"
            Effect = "Allow"
            Principal = {
                AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
            },
            Action   = "kms:*"
            Resource = "*"
        }]
    })
}














resource "aws_kms_key" "kinesis" {
    description              = "Symmetric encryption KMS key for Kinesis"

    customer_master_key_spec = "SYMMETRIC_DEFAULT"
    deletion_window_in_days  = 30
    enable_key_rotation      = false
    key_usage                = "ENCRYPT_DECRYPT"
    multi_region             = "false"


    tags = {
        Description = "Kinesis Key"
        Environment = var.environment
        Name        = "${var.environment}${var.project}-key-kinesis"
        Product     = var.product
    }
}


resource "aws_kms_key_policy" "kinesis" {
    key_id = aws_kms_key.kinesis.id
    policy = jsonencode({
        Version = "2012-10-17"
        Id      = "key-kinesis"
        Statement = [{
            Sid    = "Enable IAM User Permissions"
            Effect = "Allow"
            Principal = {
                AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
            },
            Action   = "kms:*"
            Resource = "*"
        },
        {
            "Sid": "Allow attachment of persistent resources",
            "Effect": "Allow",
            "Principal": {
                AWS: "${aws_iam_role.connect_instance.arn}"
            },
            "Action": [
                "kms:CreateGrant",
                "kms:ListGrants",
                "kms:RevokeGrant"
            ],
            "Resource": "*",
            "Condition": {
                "Bool": {
                    "kms:GrantIsForAWSResource": "true"
                }
            }
        }]
    })
}


