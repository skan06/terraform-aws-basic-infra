# Security group for RDS
resource "aws_security_group" "rds_sg" {
  name        = "rds-sg"
  description = "Allow DB access from EC2"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_sg.id,aws_security_group.bastion_sg.id] # only EC2 can access
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "RDS SG"
  }
}

# RDS subnet group
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = [aws_subnet.private_subnet.id,aws_subnet.private_subnet_2.id]

  tags = {
    Name = "RDS Subnet Group"
  }
}

# RDS MySQL instance
resource "aws_db_instance" "mydb" {
  identifier              = "myterraformdb"
  allocated_storage       = 20
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  username                = "admin"
  password                = var.db_password
  db_subnet_group_name    = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  skip_final_snapshot     = true
  publicly_accessible     = false
  multi_az                = false

  tags = {
    Name = "MyTerraformDB"
  }
}
