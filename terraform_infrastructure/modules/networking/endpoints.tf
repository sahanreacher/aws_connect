resource "aws_security_group" "dynamodb_vpc_endpoint_sg" {
    name        = "${var.environment}${var.project}-dynamo"

    description = "Security group for DynamoDB"
    vpc_id      = aws_vpc.main.id

    ingress {
        from_port       = 443
        to_port         = 443
        protocol        = "TCP"
        security_groups = [aws_security_group.lambda.id]
    }
}


resource "aws_security_group" "lambda" {
    name        = "${var.environment}${var.project}-lambda"

    description = "Security group for calling Lambda from within VPC"
    vpc_id      = aws_vpc.main.id

    egress {
        from_port = 443
        to_port   = 443
        protocol  = "tcp"

        prefix_list_ids = [
            data.aws_prefix_list.dynamodb.id
        ]
    }
}


resource "aws_vpc_endpoint" "dynamodb" {
    route_table_ids    = [for table in aws_route_table.private : table.id]
    service_name       = "com.amazonaws.${var.region}.dynamodb"
    vpc_endpoint_type  = "Gateway"
    vpc_id             = aws_vpc.main.id

    tags = {
        Description = "DynamoDB endpoint"
        Environment = var.environment
        Name        = "${var.environment}inf-endpoint-dynamodb"
        Product     = var.product
    }
}



resource "aws_vpc_endpoint" "s3" {
    route_table_ids    = [for table in aws_route_table.private : table.id]
    service_name       = "com.amazonaws.${var.region}.s3"
    vpc_endpoint_type  = "Gateway"
    vpc_id             = aws_vpc.main.id 

    tags = {
        Description = "S3 endpoint"
        Environment = var.environment
        Name        = "${var.environment}inf-endpoint-s3"
        Product     = var.product
    }
}


resource "aws_vpc_endpoint" "lambda" {
    security_group_ids = [aws_security_group.lambda.id]
    service_name       = "com.amazonaws.${var.region}.lambda"
    subnet_ids         = [for subnet in aws_subnet.private : subnet.id]
    vpc_endpoint_type  = "Interface"
    vpc_id             = aws_vpc.main.id

    tags = {
        Description = "Lambda endpoint"
        Environment = var.environment
        Name        = "${var.environment}inf-endpoint-lambda"
        Product     = var.product
    }
}
