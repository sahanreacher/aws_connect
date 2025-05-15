data "aws_iam_policy_document" "assume_role_vpc" {
    statement {
        effect = "Allow"

        principals {
            type        = "Service"
            identifiers = ["vpc-flow-logs.amazonaws.com"]
        }

        actions = ["sts:AssumeRole"]
    }
}

resource "aws_iam_role" "vpc_main" {
    name               = "${var.environment}${var.project}-vpc-main"
    assume_role_policy = data.aws_iam_policy_document.assume_role_vpc.json
}


data "aws_iam_policy_document" "vpc_logs" {
    statement {
        effect = "Allow"

        actions = [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents",
            "logs:DescribeLogGroups",
            "logs:DescribeLogStreams",
        ]

        resources = ["*"]
    }
}


resource "aws_iam_role_policy" "vpc_logs" {
    name   = "${var.environment}${var.project}-vpc-logs"
    role   = aws_iam_role.vpc_main.id
    policy = data.aws_iam_policy_document.vpc_logs.json
}
