resource "aws_lb" "my_own_load_balancer" {
  name               = "my-first-lb-for-my-archi"
  internal           = false
  load_balancer_type = "application"  
  subnets            = [aws_subnet.public_subnet_a.id, aws_subnet.public_subnet_b.id]
  enable_deletion_protection = false  # Set to true if you want to enable deletion protection
  security_groups = [aws_security_group.sg_for_my_lb.id] # Attach the security group created for the lb
}
locals {
  alb_arn = aws_lb.my_own_load_balancer.arn
}
resource "aws_lb_target_group" "my_target_group" {
  name     = "my-first-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.practvpc_002.id}"
  target_type = "instance"
}
output "target_group_arn"{
    value = aws_lb_target_group.my_target_group.arn
}
resource "aws_lb_listener" "my_aws_listener" {
  load_balancer_arn = "${aws_lb.my_own_load_balancer.arn}"
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.my_target_group.arn}"
  }
}
resource "aws_lb_listener_rule" "my_first_listener_rule" {
  listener_arn = aws_lb_listener.my_aws_listener.arn
  priority     = 1
  action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.my_target_group.arn}"
  }
  condition {
    path_pattern {
      values = ["/"]
    }
  }
}
 output "listener_rule_arn" {
    value = "aws_lb_listener.my_aws_listener.arn"
  }