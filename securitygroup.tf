resource "aws_security_group" "webserver-sg" {
  vpc_id      = aws_vpc.webserver-vpc.id
  name        = "webserver-sg"
  description = "security group for webserver"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

# ssh access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

# http access
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb-sg.id]
  }

  tags = {
    Name = "webserver-sg"
  }
}

resource "aws_security_group" "alb-sg" {
  vpc_id      = aws_vpc.webserver-vpc.id
  name        = "alb-sg"
  description = "security group for application load balancer"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    Name = "alb-sg"
  }
}

