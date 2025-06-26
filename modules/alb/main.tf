resource "aws_lb" "application_load_balancer" {
  name = "${var.project_name}-alb"
  internal = false
  load_balancer_type = "application"
  security_groups = [ var.alb_sg.id ]
  subnets = [ var.pub_sub_1a_id, var.pub_sub_2b_id ]
  enable_deletion_protection = false
  tags = {
    Name = "${var.project_name}-alb"
  }
}

# Create the target group
resource "aws_alb_target_group" "alb_target_group" {
  name = "${var.project_name}-tg"
  target_type = "instance"
  port = "80"
  protocol = "HTTP"
  vpc_id = var.vpc_id

  health_check {
    enabled = true
    interval = 300
    path = "/"
    timeout = 60
    matcher = 200               # Must return HTTP 200 to be considered healthy
    healthy_threshold = 2
    unhealthy_threshold = 5
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Create the lister port 80 with redirect action
resource "aws_alb_listener" "alb_http_listner" {
  load_balancer_arn = aws_lb.application_load_balancer.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_alb_target_group.alb_target_group.arn
  }
}
