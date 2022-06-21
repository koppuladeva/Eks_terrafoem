# Create VPC Terraform Module

# module "vpc" {
#   source  = "terraform-aws-modules/vpc/aws"
#   version = "3.14.1"
#   # insert the 23 required variables here

#  # VPC Basic Details
#   name = var.vpc_name
#   cidr = var.vpc_cidr_block
#   azs             = var.vpc_availability_zones
#   public_subnets  = var.vpc_public_subnets
#   private_subnets = var.vpc_private_subnets  

#   # NAT Gateways - Outbound Communication
#   enable_nat_gateway = var.vpc_enable_nat_gateway 
#   single_nat_gateway = var.vpc_single_nat_gateway

#   # VPC DNS Parameters
#   enable_dns_hostnames = true
#   enable_dns_support   = true


# }

  
  
resource "aws_vpc" "eks_vpc" {
  cidr_block       = "10.20.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "eks_cluster_shared"
  }
}

resource "aws_subnet" "public-subnet" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = "10.20.1.0/24"
  map_public_ip_on_launch = true
  #availability_zone

  tags = {
    Name = "public_subnet"
  }
}

resource "aws_subnet" "private-subnet" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = "10.20.2.0/24"
  map_public_ip_on_launch = false
  #availability_zone

  tags = {
    Name = "private_subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.eks_vpc.id

  tags = {
    Name = "eks_igw"
  }
}

resource "aws_internet_gateway_attachment" "igw-attachment" {
  internet_gateway_id = aws_internet_gateway.igw.id
  vpc_id              = aws_vpc.eks_vpc.id
}

resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.eks_vpc.id

  route {
    cidr_block = "10.20.1.0/24"
    gateway_id = aws_internet_gateway.igw-attachment.id
  }
  tags = {
    Name = "public_route_table"
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  # allocation_id = aws_eip.example.id
  subnet_id = aws_subnet.public-subnet.id

  tags = {
    Name = "NatGateway"
  }
}

resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.eks_vpc.id

  route {
    cidr_block     = "10.20.2.0/24"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }
  tags = {
    Name = "private_route_table"
  }
}

resource "aws_route_table_association" "public-route-table-association" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.public-route-table.id
}

resource "aws_route_table_association" "public-route-table-association" {
  subnet_id      = aws_subnet.private-subnet.id
  route_table_id = aws_route_table.private-route-table.id
}
