#creating a new VPC#
resource "aws_vpc" "a1vpc" {
  cidr_block = "10.0.0.0/16"  

  tags = {
    Name = "assigment1VPC"
  }
}
#####IGW############
resource "aws_internet_gateway" "a1igw" {
  vpc_id = aws_vpc.a1vpc.id

  tags = {
    Name = "assignment1igw"
  }
}

############ Public Subnet ################
resource "aws_subnet" "subnet1" {
  vpc_id                  = aws_vpc.a1vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "subnet1"
  }
}
################Security Group###########
resource "aws_security_group" "allow_tls" {
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.a1vpc.id

  ingress {
    description      = "AllowHttp"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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
    Name = "allow_http"
  }
}

##########Two EC2 Instances############
resource "aws_instance" "server1" {
  ami           = "ami-0cca134ec43cf708f"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnet1.id
  vpc_security_group_ids = [aws_security_group.allow_tls.id]

  tags = {
    Name = "server1-instance"
  }
}

resource "aws_instance" "server2" {
  ami           = "ami-0cca134ec43cf708f"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnet1.id
  vpc_security_group_ids = [aws_security_group.allow_tls.id]

  tags = {
    Name = "server1-instance"
  }
}

##########LoadBalancer######
resource "aws_lb" "a1lb" {
  name               = "a1-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_tls.id]
  subnets            = [aws_subnet.subnet1.id]

  tags = {
    Name = "Assigment1-lb"
  }
}
#########Target Group #########

# Create a target group
resource "aws_lb_target_group" "a1tg" {
  name     = "assignment-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.a1vpc.id

  tags = {
    Name = "assinment1-target-group"
  }
}

# Attach instances to the target group
resource "aws_lb_target_group_attachment" "example_tg_attachment_1" {
  target_group_arn = aws_lb_target_group.a1tg.arn
  target_id        = aws_instance.server1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "example_tg_attachment_2" {
  target_group_arn = aws_lb_target_group.a1tg.arn
  target_id        = aws_instance.server2.id
  port             = 80
}
