resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr_block

    tags = {
        Description = "Main VPC"
        Environment = var.environment
        Name        = "${var.environment}inf-vpc"
        Product     = var.product
    }
}


resource "aws_default_security_group" "main" {
    vpc_id      = aws_vpc.main.id

    tags = {
        Name = "${var.environment}inf-main-sg"
    }
}


resource "aws_default_route_table" "main" {
    default_route_table_id = aws_vpc.main.default_route_table_id

    tags = {
        Description = "Main Routing Table"
        Environment = var.environment
        Name        = "${var.environment}inf-main-rt"
        Product     = var.product
    }
}


resource "aws_network_acl" "private" {
    vpc_id = aws_vpc.main.id

    egress {
        action     = "allow"
        cidr_block = "0.0.0.0/0"
        from_port  = 443
        protocol   = "tcp"
        rule_no    = 100
        to_port    = 443
    }

    ingress {
        action     = "allow"
        cidr_block = "0.0.0.0/0"
        from_port  = 1024
        protocol   = "tcp"
        rule_no    = 100
        to_port    = 65535
    }

    tags = {
        Description = "Main ACL"
        Environment = var.environment
        Name        = "${var.environment}inf-private-acl"
        Product     = var.product
    }
}
