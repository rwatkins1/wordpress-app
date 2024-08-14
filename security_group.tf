resource "aws_security_group" "app_sg" {
  name        = var.app_sg_name
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = module.vpc.vpc_id
  depends_on = [ module.vpc ]

  tags = {
    Name = "app-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.app_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

  # Allow traffic from the load balancer security group

# resource "aws_vpc_security_group_ingress_rule"  "alb" {
#     security_group_id = aws_security_group.app_sg.id
#     referenced_security_group_id = aws_security_group.lb_sg.id
#     from_port       = 80
#     to_port         = 80
#     ip_protocol        = "tcp"
#   }

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.app_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.app_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_security_group" "db_sg" {
  name        = var.db_sg_name
  description = "Security group for MySQL database"
  vpc_id      = module.vpc.vpc_id 

  # Inbound rule to allow MySQL traffic from the application layer
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
    security_groups = [aws_security_group.app_sg.id]  # Reference to the application security group
  }

  # Outbound rule to allow all traffic (default)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "db_sg"
  }
}
