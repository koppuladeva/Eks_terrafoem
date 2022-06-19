# Create VPC Terraform Module

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.1"
  # insert the 23 required variables here

 # VPC Basic Details
  name = var.vpc_name
  cidr = var.vpc_cidr_block
  azs             = var.vpc_availability_zones
  public_subnets  = var.vpc_public_subnets
  private_subnets = var.vpc_private_subnets  

  # NAT Gateways - Outbound Communication
  enable_nat_gateway = var.vpc_enable_nat_gateway 
  single_nat_gateway = var.vpc_single_nat_gateway

  # VPC DNS Parameters
  enable_dns_hostnames = true
  enable_dns_support   = true


}
