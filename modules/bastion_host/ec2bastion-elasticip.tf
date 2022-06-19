# Create Elastic IP for Bastion Host
# Resource - depends_on Meta-Argument
resource "aws_eip" "bastion_eip" {
  depends_on = [module.ec2_public_bastion, module.vpc ]
  instance = module.ec2_public_bastion.id
  vpc      = true  
}