# VPC
resource "aws_vpc" "ecommerce_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "ecommerce-vpc"
  }
}

# Subnet
resource "aws_subnet" "ecommerce_subnet" {
  vpc_id                  = aws_vpc.ecommerce_vpc.id
  cidr_block              = var.subnet_cidr
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "ecommerce-subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "ecommerce_igw" {
  vpc_id = aws_vpc.ecommerce_vpc.id

  tags = {
    Name = "ecommerce-igw"
  }
}

# Route Table
resource "aws_route_table" "ecommerce_rt" {
  vpc_id = aws_vpc.ecommerce_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ecommerce_igw.id
  }

  tags = {
    Name = "ecommerce-rt"
  }
}

# Route Table Association
resource "aws_route_table_association" "ecommerce_rta" {
  subnet_id      = aws_subnet.ecommerce_subnet.id
  route_table_id = aws_route_table.ecommerce_rt.id
}

# Security Group
resource "aws_security_group" "ecommerce_sg" {
  name        = "ecommerce-microservices-sg"
  description = "Allow inbound traffic for frontend and microservices"
  vpc_id      = aws_vpc.ecommerce_vpc.id

  # SSH Access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Frontend (React / Nginx)
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # User Service
  ingress {
    from_port   = 3001
    to_port     = 3001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Product Service
  ingress {
    from_port   = 3002
    to_port     = 3002
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Cart Service
  ingress {
    from_port   = 3003
    to_port     = 3003
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Order Service
  ingress {
    from_port   = 3004
    to_port     = 3004
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound Internet Access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}