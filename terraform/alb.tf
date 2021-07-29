resource "aws_lb" "alb" {
  name               = "alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = data.aws_subnet_ids.subnets.ids
}

resource "aws_lb_target_group" "group" {
  name        = "target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.ecs-vpc.id
  target_type = "instance"
  depends_on = [aws_lb.alb]
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.group.arn
  }
}