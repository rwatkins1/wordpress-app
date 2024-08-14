variable "app_sg_name" {
    description = "The security group ID to associate with the resources."
    type = string
    default = "app-sg"
}

variable "db_sg_name" {
    description = "The security group ID to associate with the resources."
    type = string
    default = "db_sg"
}

variable "private_subnets" {
  description = "List of private subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24"]
}

variable "public_subnets" {
  description = "List of public subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}
