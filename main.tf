provider "aws" {
  region = "ap-south-1"
  access_key = "AKIAZ724JTV6ZK3EYFRW"
  secret_key = "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"
}

resource "aws_instance" "TerraformEC2" {
  ami           = "ami-0cca134ec43cf708f"
  instance_type = "t2.micro"

  tags = {
    Name = "TerraformEC2-instance"
  }
}
##############
provider "aws" {
  region = "ap-south-1"
  access_key = "AKIAZ724JTV6ZK3EYFRW"
  secret_key = "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"
}

variable "instance_type" {
    default = "t2micro"
}

variable "availability_zone_1" {
  default = "ap-south-1a"
}

variable "availability_zone_2" {
  default = "ap-south-1b"
}


resource "aws_instance" "TerraformEC2" {
  ami           = "ami-0cca134ec43cf708f"
  instance_type = var.instance_type
  availability_zone = var.availability_zone_1

  tags = {
    Name = "TerraformEC2-instance"
  }
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.myvpc.id

  ingress {
    description      = "all_traffic"
    from_port        = 0    #All Traffic
    to_port          = 0    #All Traffic
    protocol         = "-1" #All Traffic
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = null
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_db_instance" "mydbinstance" {
  allocated_storage    = 10
  db_name              = "mydb"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  username             = "admin"
  password             = "password"
  availability_zone    = var.availability_zone_2 
  skip_final_snapshot  = true
}

resource "aws_db_security_group" "default" {
  name = "rds_sg"

  ingress {
    cidr = "10.0.0.0/24"
  }
}

resource "aws_security_group_rule" "rds_allow_ec2_ingress" {
  type        = "ingress"
  from_port   = 3306
  to_port     = 3306
  protocol    = "tcp"
  security_group_id = aws_security_group.rds.id
  source_security_group_id = aws_security_group.allowtls.id
}

