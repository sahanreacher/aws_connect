resource "aws_cloudwatch_log_group" "vpc" {
    name = "${var.environment}${var.project}-vpc"
}


resource "aws_flow_log" "main" {
    iam_role_arn    = aws_iam_role.vpc_main.arn
    log_destination = aws_cloudwatch_log_group.vpc.arn
    traffic_type    = "ALL"
    vpc_id          = aws_vpc.main.id
}
