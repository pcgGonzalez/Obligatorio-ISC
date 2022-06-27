

resource "aws_vpc" "vpc-ms" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "vpc-ms"
  }

}


resource "aws_internet_gateway" "igw-ms" {
    vpc_id = aws_vpc.vpc-ms.id
    tags = {
        Name = "igw-ms" 
    }
  
}

resource "aws_subnet" "subnet-pivot" {
  cidr_block = "10.0.0.0/24"
  vpc_id = aws_vpc.vpc-ms.id
  availability_zone = "us-east-1a"
  tags = {
    Name = "subnet-pivot"
  }
}

resource "aws_subnet" "subnet-ms-az-a" {
  cidr_block = "10.0.1.0/24"
  vpc_id = aws_vpc.vpc-ms.id
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "subnet-ms-az-a"
  }
}

resource "aws_subnet" "subnet-ms-az-b" {
  cidr_block = "10.0.2.0/24"
  vpc_id = aws_vpc.vpc-ms.id
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "subnet-ms-az-b"
  }
}

resource "aws_default_route_table" "route-ms" {
  default_route_table_id = aws_vpc.vpc-ms.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-ms.id
  }
  tags = {
    Name = "Route-Table-ms"
  }
}
