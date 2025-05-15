output "lambda_sg_id" {
    value = aws_security_group.lambda.id
}


output "public_cidr_blocks" {
    value = [for subnet in aws_subnet.public : subnet.id]
}


output "private_cidr_blocks" {
    value = [for subnet in aws_subnet.private : subnet.id]
}


output "vpc_cidr_block" {
    value = var.vpc_cidr_block
}


output "vpc_id" {
    value = aws_vpc.main.id
}
