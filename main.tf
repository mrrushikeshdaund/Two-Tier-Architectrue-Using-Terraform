
variable aws_access_key {}

variable aws_secret_key {}

variable region {
    default = "us-east-1"
}

provider "aws" {
    access_key = var.aws_access_key
    secret_key = var.aws_secret_key
    region = var.region
}

resource "aws_vpc" "My-VPC" {
    cidr_block = "10.0.0.0/16"
    tags = {
        "Name" = "My-VPC"
    }
}

resource "aws_subnet" "PublicSubnet" {
    cidr_block = "10.0.0.0/24"
    vpc_id = aws_vpc.My-VPC.id
    tags = {
        "Name" = "Public Subnet"
    }
}

resource "aws_subnet" "PrivateSubnet" {
    cidr_block = "10.0.1.0/24"
    vpc_id = aws_vpc.My-VPC.id
    tags = {
        "Name" = "Private Subnet"
    }
}


resource "aws_internet_gateway" "IGW" {
    vpc_id = aws_vpc.My-VPC.id
    tags = {
        "Name" = "IGW"
    }
}

resource "aws_eip" "Nat-ip" {
    vpc = true
}

resource "aws_nat_gateway" "NAT" {
    subnet_id = aws_subnet.PublicSubnet.id
    allocation_id = aws_eip.Nat-ip.id
    depends_on = [aws_internet_gateway.IGW]
    tags = {
        "Name" = "NAT"
    }
}

resource "aws_route_table" "PublicRouteTable" {
    vpc_id = aws_vpc.My-VPC.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.IGW.id
    }
    tags = {
        "Name" = "Public Route Table"
    }
}

resource "aws_route_table" "PrivateRouteTable" {
    vpc_id = aws_vpc.My-VPC.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.NAT.id
    }
    tags = {
        "Name" = "Private Route Table"
    }
}

resource "aws_route_table_association" "Public_route" {
    subnet_id = aws_subnet.PublicSubnet.id
    route_table_id = aws_route_table.PublicRouteTable.id
}

resource "aws_route_table_association" "Private_route" {
    subnet_id = aws_subnet.PrivateSubnet.id
    route_table_id = aws_route_table.PrivateRouteTable.id
}