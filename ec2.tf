module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  name = "wordpress-app"
  instance_type          = "t3.micro"
  key_name               = "demo"
  ami                    = "ami-03972092c42e8c0ca"
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  subnet_id              = module.vpc.public_subnets[0]
  associate_public_ip_address = true
}

# # module "ec2_instance2" {
# #   source  = "terraform-aws-modules/ec2-instance/aws"
# #   name = "wordpress-app2"
# #   instance_type          = "t3.micro"
# #   ami                    = "ami-03972092c42e8c0ca"
# #   key_name               = "demo"
# #   vpc_security_group_ids = [aws_security_group.app_sg.id]
# #   subnet_id              = module.vpc.public_subnets[1]
# #   associate_public_ip_address = true
#
# #  }

# output "ec2_instance" {
#   value = module.ec2_instance.id
# }