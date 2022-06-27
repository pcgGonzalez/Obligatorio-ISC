provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

resource "aws_vpc" "vpc_obligatorio" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "internetgw" {
    vpc_id = aws_vpc.vpc_obligatorio.id
    tags = {
        Name = "igwdevpc_obligatorio" 
    }
  
}

resource "aws_subnet" "SUBNET_1" {
  cidr_block = "10.0.1.0/24"
  vpc_id = aws_vpc.vpc_obligatorio.id
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "subnet_1_obl"
  }
}

resource "aws_subnet" "SUBNET_2" {
  cidr_block = "10.0.2.0/24"
  vpc_id = aws_vpc.vpc_obligatorio.id
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "subnet_2_obl"
  }
}


resource "aws_default_route_table" "obl_route_table" {
    default_route_table_id = aws_vpc.vpc_obligatorio.default_route_table_id

    route {

      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.internetgw.id
    }
    tags = {
      Name = "Route-table-obligatorio"    
    }
    
}
