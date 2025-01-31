resource "aws_db_subnet_group" "main" {
  name       = "production-db-subnet-group"
  subnet_ids = var.private_subnets
}

resource "aws_db_instance" "main" {
  identifier             = "production-db"
  engine                 = "postgres"
  engine_version         = "13.4"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  storage_type           = "gp2"
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [var.db_security_group_id]
  skip_final_snapshot    = true
  publicly_accessible    = false
}

output "db_endpoint" {
  value = aws_db_instance.main.endpoint
}