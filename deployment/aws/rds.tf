resource "aws_db_subnet_group" "my_db_subnet_group" {
  name       = "my-db-subnet-group"
  subnet_ids = aws_subnet.public_subnets[*].id
  tags = {
    Name = "My DB Subnet Group"
  }
}

resource "aws_security_group" "rds_sg" {
  name_prefix = "rds-"

  vpc_id = aws_vpc.main.id

  # Add any additional ingress/egress rules as needed
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["76.183.229.179/32"]
  }
}

resource "aws_db_instance" "default" {
  allocated_storage = 10
  storage_type      = "gp2"
  engine            = "mariadb"
  engine_version    = "10.11.7"
  instance_class    = "db.t3.micro"
  identifier        = "mydb"
  username          = "dbuser"
  password          = "dbpassword"

  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.my_db_subnet_group.name

  skip_final_snapshot = true
  publicly_accessible = true
}