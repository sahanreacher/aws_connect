resource "aws_iam_role" "connect_instance" {
    name = "${var.environment}${var.project}_connect_service"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = "sts:AssumeRole"
                Effect = "Allow"
                Sid    = ""
                Principal = {
                    Service = "connect.amazonaws.com"
                }
            },
        ]
    })

    tags = {
        Description = "Agent events stream"
        Environment = var.environment
        Name        = "${var.environment}${var.project}_connect_service"
        Product     = "Defra Connect Platform"
    }
}

















#resource "aws_iam_role" "lambda" {
#    name = "Lambda_${var.environment}"
#
#    assume_role_policy = jsonencode({
#        Version = "2012-10-17"
#        Statement = [
#            {
#                Action = "sts:AssumeRole"
#                Effect = "Allow"
#                Sid    = ""
#                Principal = {
#                    Service = "lambda.amazonaws.com"
#                }
#            },
#        ]
#    })
#
#    tags = {
#        Description = "Agent events stream"
#        Environment = var.environment
#        Name        = "${var.project}-${var.environment}-kinesis-datastream-agentevents"
#        Product     = "Defra Connect Platform"
#    }
#}


#resource "aws_iam_role_policy_attachment" "lamda_AmazonDynamoDBReadOnlyAccess" {
#    role       = aws_iam_role.lambda.name
#    policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBReadOnlyAccess"
#}

#resource "aws_iam_role_policy_attachment" "lamda_AWSLambdaDynamoDBExecutionRole" {
#    role       = aws_iam_role.lambda.name
#    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaDynamoDBExecutionRole"
#}


#resource "aws_iam_policy" "lambda_AWSLambdaBasicExecutionRole" {
#    name        = "test_policy"
#    path        = "/"
#    description = "My test policy"
#
#    policy = jsonencode({
#       
#    })
#}








resource "aws_iam_role" "firehose" {
    #name = "AWSServiceRoleforAmazonConnect_${var.environment}"
    name = "${var.environment}${var.project}-firehose_service"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = "sts:AssumeRole"
                Effect = "Allow"
                Sid    = ""
                Principal = {
                    Service = "firehose.amazonaws.com"
                }
            },
        ]
    })

    tags = {
        Description = "Agent events stream"
        Environment = var.environment
        Name        = "${var.environment}${var.project}-firehose_service"
        Product     = var.product
    }
}


resource "aws_iam_policy" "firehose" {
    name        = "${var.environment}${var.project}-firehose_policy"
    path        = "/"
    description = "Firehose Policy"

    policy = jsonencode({
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "",
                "Effect": "Allow",
                "Action": [
                    "s3:AbortMultipartUpload",
                    "s3:GetBucketLocation",
                    "s3:GetObject",
                    "s3:ListBucket",
                    "s3:ListBucketMultipartUploads",
                    "s3:PutObject"
                ],
                "Resource": [
                    #"arn:aws:s3:::defra-dev-s3-bucket-connecttelephony-001",
                    #"arn:aws:s3:::defra-dev-s3-bucket-connecttelephony-001/*"
                    "${aws_s3_bucket.telephony.arn}",
                    "${aws_s3_bucket.telephony.arn}/*"
                ]
            },
            {
                "Sid": "",
                "Effect": "Allow",
                "Action": [
                    "kinesis:DescribeStream",
                    "kinesis:GetShardIterator",
                    "kinesis:GetRecords",
                    "kinesis:ListShards"
                ],
                #"Resource": "arn:aws:kinesis:eu-west-2::stream/defra-dev-kinesis-datastream-agentevents-001"
                
                # Chicken and egg - cannot create the Stream without attaching a policy
                # and cannot create the policy without knowing the ARN,
                #"Resource": "${aws_kinesis_stream.agent_events.arn}"
                #"Resource": "${aws_kinesis_stream.ctr.arn}"
                "Resource": [      
                    "arn:aws:kinesis:eu-west-2::stream",
                    "arn:aws:kinesis:eu-west-2::stream/*",
                    "*"
                ],
            },
            {
                "Effect": "Allow",
                "Action": [
                    "kms:Decrypt"
                ],
                "Resource": [
                    # TODO - pull out correct key
                    #"arn:aws:kms:eu-west-2::key/35837b73-c315-4e58-bde2-c45d352fa667"
                    "${aws_kms_key.telephony.arn}"
                ],
                # TODO - work this out.
                #"Condition": {
                #    "StringEquals": {
                #        "kms:ViaService": "kinesis.eu-west-2.amazonaws.com"
                #    },
                #    "StringLike": {
                #        #"kms:EncryptionContext:aws:kinesis:arn": "arn:aws:kinesis:eu-west-2::stream/defra-dev-kinesis-datastream-agentevents-001"
                #        # TODO - pull out correct stream
                #        # Chicken and egg again
                #        "kms:EncryptionContext:aws:kinesis:arn": "${aws_kinesis_stream.agent_events.arn}"
                #        "kms:EncryptionContext:aws:kinesis:arn": "${aws_kinesis_stream.ctr.arn}"
                #    }
                #}
            }
        ]
    })
}


resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.firehose.name
  policy_arn = aws_iam_policy.firehose.arn
}
