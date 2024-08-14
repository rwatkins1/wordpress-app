terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.60.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  create_igw = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

output "public_subnet" {
  value = module.vpc.public_subnets[*]
}

output "cidr" {
  value = module.vpc.vpc_cidr_block
}

output "name" {
  value = module.vpc.vpc_id
}

output "private_subnet" {
  value = module.vpc.private_subnets[*]
}