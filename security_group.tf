resource "aws_security_group" "rds-server-sg" {
 name_prefix = "rds-server-sg"
 description = "Security group allowing 3306 access"
 ingress {
   from_port   = 3306
   to_port     = 3306
   protocol    = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
 }
  egress {
   from_port   = 0
   to_port     = 0
   protocol    = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }


 tags = {
   Name = "RDSSecurityGroup"
 }
}

