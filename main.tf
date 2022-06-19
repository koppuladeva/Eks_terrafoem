terraform {
  required_version = "~> 0.14" # which means any version equal & above 0.14 like 0.15, 0.16 etc and < 1.xx
  required_providers {
     aws = {
       source = "hashicorp/aws"
       version = "~>4.19"
     }
  } 
}  
# Provider Block
provider "aws" {
  region = "us-east-1"
}

module "eks-vpc" {
    source = "./modules/eks_vpc"
    vpc_name = "eks_vpc"
    vpc_cidr_block = "10.10.0.0/16"
    vpc_availability_zones = ["us-east-1a", "us-east-1b"]
    vpc_public_subnets = ["10.10.10.0/24", "10.0.11.0/24"]
    vpc_private_subnets = ["10.10.1.0/24", "10.10.2.0/24"]
    #vpc_enable_nat_gateway = var.vpc_enable_nat_gateway
    #vpc_single_nat_gateway = var.vpc_single_nat_gateway
}

module "bastion-host" {
  source = "./modules/bastion_host"
  instance_type = "t3.micro"
}