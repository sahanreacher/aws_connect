# IAM Role for Kinesis Firehose
resource "aws_iam_role" "firehose_service_role" {
  name = "${lower(local.name_prefix)}-firehose-service-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "firehose.amazonaws.com"
        }
      }
    ]
  })
  tags = merge(tomap({ "Name" = "${lower(local.name_prefix)}logicmonitor-role" }),
  local.required_tags)
}

# IAM Policy for Kinesis Stream Access
resource "aws_iam_role_policy" "kinesis_stream_policy" {
  name = "${lower(local.name_prefix)}-kinesis-stream-policy"
  role = aws_iam_role.firehose_service_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "kinesis:DescribeStream",
          "kinesis:GetShardIterator",
          "kinesis:GetRecords",
          "kinesis:ListShards"
        ]
        Resource = [
          "*"
        ],
      }
    ]
  })
}

# IAM Policy for S3 Access
resource "aws_iam_role_policy" "kinesis_s3_policy" {
  name = "${lower(local.name_prefix)}-kinesis-s3-policy"
  role = aws_iam_role.firehose_service_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:AbortMultipartUpload",
          "s3:GetBucketLocation",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:ListBucketMultipartUploads",
          "s3:PutObject"
        ]
        Resource = [
          "${data.terraform_remote_state.s3_state.outputs.con_bucket_arn}",
          "${data.terraform_remote_state.s3_state.outputs.con_bucket_arn}/*"
        ]
      }
    ]
  })
}

# IAM Policy for CloudWatch Logs Access
resource "aws_iam_role_policy" "kinesis_cloudwatch_policy" {
  name = "${lower(local.name_prefix)}-kinesis-cloudwatch-policy"
  role = aws_iam_role.firehose_service_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "cloudwatch:PutMetricData"
        ]
        Resource = [
          "*"
        ]
      }
    ]
  })
}

# IAM Policy for KMS Access
resource "aws_iam_role_policy" "kinesis_kms_policy" {
  name = "${lower(local.name_prefix)}-kinesis-kms-policy"
  role = aws_iam_role.firehose_service_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "kms:Decrypt",
          "kms:GenerateDataKey"
        ]
        Resource = [
          "*"
        ]
      }
    ]
  })
}
