resource "aws_subnet" "public" {
    count             = var.public_subnet_count

    availability_zone = data.aws_availability_zones.available.names[count.index % length(data.aws_availability_zones.available.names)]
    cidr_block        = cidrsubnet(var.vpc_cidr_block,8,count.index)
    vpc_id            = aws_vpc.main.id
    
    tags = {
        Description = "Public Subnet ${count.index}"
        Environment = var.environment
        Name        = "${var.environment}inf-public-${count.index}"
        Product     = var.product
    }
}


resource "aws_subnet" "private" {
    count             = var.private_subnet_count

    availability_zone = data.aws_availability_zones.available.names[count.index % length(data.aws_availability_zones.available.names)]
    cidr_block        = cidrsubnet(var.vpc_cidr_block,8,count.index + var.public_subnet_count)
    vpc_id            = aws_vpc.main.id

    tags = {
        Description = "Private Subnet ${count.index}"
        Environment = var.environment
        Name        = "${var.environment}inf-private-${count.index}"
        Product     = var.product
    }
}


resource "aws_route_table" "private" {
    count  = var.private_subnet_count

    vpc_id = aws_vpc.main.id

    tags = {
        Description = "Private Routing Table ${count.index}"
        Environment = var.environment
        Name        = "${var.environment}inf-private-${count.index}"
        Product     = var.product
    }
}

resource "aws_route_table_association" "private" {
    count          = var.private_subnet_count

    route_table_id = aws_route_table.private[count.index].id
    subnet_id      = aws_subnet.private[count.index].id  
}


resource aws_network_acl_association "private" {
    count = var.private_subnet_count

    network_acl_id = aws_network_acl.private.id
    subnet_id = aws_subnet.private[count.index].id
}
