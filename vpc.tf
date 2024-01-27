provider "aws" {
  region = var.AWS_REGION
}

terraform {
  required_version = ">= 1.4"
}

# VPC
resource "aws_vpc" "webserver-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  instance_tenancy     = "default"
  tags = {
    Name = "webserver-vpc"
  }
}

# Public Subnets
resource "aws_subnet" "public-subnet-1" {
  vpc_id                  = aws_vpc.webserver-vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-2a"

  tags = {
    Name = "public-subnet-1"
  }
}

resource "aws_subnet" "public-subnet-2" {
  vpc_id                  = aws_vpc.webserver-vpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-2b"

  tags = {
    Name = "public-subnet-2"
  }
}

# Public Subnets

resource "aws_subnet" "private-subnet-1" {
  vpc_id                  = aws_vpc.webserver-vpc.id
  cidr_block              = "10.0.4.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "us-east-2a"

  tags = {
    Name = "private-subnet-1"
  }
}

resource "aws_subnet" "private-subnet-2" {
  vpc_id                  = aws_vpc.webserver-vpc.id
  cidr_block              = "10.0.5.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "us-east-2b"

  tags = {
    Name = "private-subnet-2"
  }
}


# Internet GateWay
resource "aws_internet_gateway" "int-gw" {
  vpc_id = aws_vpc.webserver-vpc.id

  tags = {
    Name = "int-gw"
  }
}

# route table
resource "aws_route_table" "rt-public" {
  vpc_id = aws_vpc.webserver-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.int-gw.id
  }

  tags = {
    Name = "rt-public"
  }
}


# route associations public
resource "aws_route_table_association" "main-public-1-a" {
  subnet_id      = aws_subnet.public-subnet-1.id
  route_table_id = aws_route_table.rt-public.id
}

resource "aws_route_table_association" "main-public-2-a" {
  subnet_id      = aws_subnet.public-subnet-2.id
  route_table_id = aws_route_table.rt-public.id
}

