resource "aws_internet_gateway" "public" {
    vpc_id = aws_vpc.main.id

    tags = {
        Description = "NAT Gateway"
        Environment = var.environment
        Name        = "${var.environment}inf-internet-gateway"
        Product     = var.product
    }
}


resource "aws_nat_gateway" "public" {
    count             = var.public_subnet_count

    connectivity_type = "private"
    subnet_id         = aws_subnet.public[count.index].id

    tags = {
        Description = "NAT Gateway"
        Environment = var.environment
        Name        = "${var.environment}inf-nat-gateway-${count.index}"
        Product     = var.product
    }

    depends_on = [aws_internet_gateway.public]
}
