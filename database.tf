resource "aws_db_subnet_group" "db-subnet-grp" {
  name       = "db-subnet-grp"
  subnet_ids = [module.vpc.private_subnets[0], module.vpc.private_subnets[1]]
  depends_on = [ module.vpc ]

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_db_instance" "database" {
  allocated_storage    = 10
  db_name              = "mydb"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  username             = "admin"
  password             = "XXXXXXXX"
  skip_final_snapshot  = true
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  db_subnet_group_name = "db-subnet-grp"
  depends_on = [ aws_db_subnet_group.db-subnet-grp ]

}