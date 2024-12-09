resource "aws_db_instance" "mysql-server" {
 engine                 = "mysql"
 db_name                = var.db-name
 instance_class         = "db.t4g.micro"
 allocated_storage      = 20
 engine_version         = "8.0"
 parameter_group_name   = "default.mysql8.0"
 publicly_accessible    = true
 username               = var.db-username
 password               = var.db-password
 vpc_security_group_ids = [aws_security_group.rds-server-sg.id]
 skip_final_snapshot    = true     
  tags = {
   Name = "${var.db-name}-db"
 }
}
