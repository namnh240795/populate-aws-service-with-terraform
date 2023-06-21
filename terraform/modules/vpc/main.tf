resource "aws_vpc" "main" {
    cidr_block = var.cidr
    tags = {
      Name = "${var.vpc_name}-${var.environment}"
      Environment = var.environment
    }
}

resource "aws_subnet" "private" {
    vpc_id = aws_vpc.main.id
    cidr_block        = element(var.private_subnets, count.index)
    availability_zone = element(var.availability_zones, count.index)
    count = length(var.private_subnets)

    tags = {
        Name = "${var.vpc_name}-${var.environment}-private-${count.index}"
        Environment = var.environment
    }
}

resource "aws_subnet" "public" {
    vpc_id = aws_vpc.main.id
    cidr_block        = element(var.public_subnets, count.index)
    availability_zone = element(var.availability_zones, count.index)
    count = length(var.public_subnets)
    tags = {
        Name = "${var.vpc_name}-${var.environment}-public-${count.index}"
        Environment = var.environment
    }
}