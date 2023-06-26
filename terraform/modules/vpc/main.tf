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


// Attach Internet Gateway to VPC
resource "aws_internet_gateway" "internet_gateway" {
    vpc_id = aws_vpc.main.id
    tags = {
        Name = "${var.vpc_name}-${var.environment}-igw"
        Environment = var.environment
    }
}

// Attach route table to VPC
resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id
    tags = {
        Name = "${var.vpc_name}-${var.environment}-public-route-table"
        Environment = var.environment
    }
}

// Attach route to route table
resource "aws_route" "public" {
    route_table_id         = aws_route_table.public.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id             = aws_internet_gateway.internet_gateway.id
}

// Assiocate route table with public subnet
resource "aws_route_table_association" "public" {
    subnet_id      = element(aws_subnet.public.*.id, count.index)
    route_table_id = element(aws_route_table.public.*.id, count.index)
    count = length(var.public_subnets)
}

resource "aws_key_pair" "ec2_key_pem" {
    key_name   = "${var.vpc_name}-${var.environment}-ec2-key"
    public_key = file("../.ssh/aws_tf.pub")
}

resource "aws_security_group" "ec2_to_internet" {
    name        = "${var.vpc_name}-${var.environment}-allow-http"
    description = "allow everything"
    vpc_id      = aws_vpc.main.id

    ingress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"] 
    }
}

data "aws_ec2_instance_type" "t2_micro" {
    instance_type = "t2.micro"
}

data "aws_ami" "aws_ubuntu" {
  most_recent = true
  owners      = ["amazon"]


  filter {
    name   = "name"
    values = ["amzn-ami-hvm*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}

// Create EC2 instance
resource "aws_instance" "ec2" {
    ami = data.aws_ami.aws_ubuntu.id
    instance_type = data.aws_ec2_instance_type.t2_micro.id
    key_name = aws_key_pair.ec2_key_pem.key_name
    vpc_security_group_ids = [aws_security_group.ec2_to_internet.id]
    subnet_id = element(aws_subnet.public.*.id, 0)
    associate_public_ip_address = true
    tags = {
        Name = "${var.vpc_name}-${var.environment}-ec2"
        Environment = var.environment
    }
}