resource "aws_key_pair" "mykeypair" {
  key_name   = "mykeypair"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
  lifecycle {
    ignore_changes = [public_key]
  }
}

resource "aws_launch_template" "launchtemplate" {
  name_prefix     = "launchtemplate"
  image_id        = var.AMIS[var.AWS_REGION]
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.mykeypair.key_name
  vpc_security_group_ids = [aws_security_group.webserver-sg.id]
  user_data       = filebase64("script.sh")

}

resource "aws_autoscaling_group" "example-autoscaling" {
  name                      = "autoscaling"
  vpc_zone_identifier       = [aws_subnet.public-subnet-1.id, aws_subnet.public-subnet-2.id]
  launch_template {
    id = aws_launch_template.launchtemplate.id
    version = "$Latest"
  }
  desired_capacity          = 2
  min_size                  = 2
  max_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  target_group_arns = ["${aws_alb_target_group.group.arn}"]
  force_delete              = true

  tag {
    key                 = "Name"
    value               = "ec2 instance"
    propagate_at_launch = true
  }
}
