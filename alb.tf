
resource "aws_alb" "alb" {
  name            = "alb"
  security_groups = ["${aws_security_group.alb-sg.id}"]
  subnets         = ["${aws_subnet.public-subnet-1.id}", "${aws_subnet.public-subnet-2.id}"]

}

resource "aws_alb_target_group" "group" {
  name     = "alb-target"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.webserver-vpc.id}"
}

resource "aws_alb_listener" "listener_http" {
  load_balancer_arn = "${aws_alb.alb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.group.arn}"
    type             = "forward"
  }
}
