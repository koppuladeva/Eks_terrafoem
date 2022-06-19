# AWS EC2 Instance Terraform Module
# Bastion Host - EC2 Instance that will be created in VPC Public Subnet
module "ec2_public_bastion" {
    source  = "terraform-aws-modules/ec2-instance/aws"
    version = "4.0.0"

  name = "eks-BastionHost"
  ami                    = data.aws_ami.amzlinux2.id
  instance_type          = var.instance_type
#  key_name               = var.instance_keypair //change accordingly
  #monitoring             = true
  subnet_id              = {
    source = "./module.vpc"
    subnet_id = [module.vpc.public_subnets[0]]
  } 
  vpc_security_group_ids = [module.public_bastion_sg.security_group_id]
  
}