#  Creating Application Load Balancer (ALB)
resource "aws_lb" "app_lb" {
  name               = "aws-app-prod-lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = aws_subnet.public_subnet.*.id

  security_groups = [aws_security_group.alb_sg.id]

  tags = merge(
    var.common_tags,
    {
      Name = "Application Load Balancer"
    }
  )
}

#  Creating Security Group for Load Balancer
resource "aws_security_group" "alb_sg" {
  name        = "alb-security-group"
  description = "Allow web traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.common_tags,
    {
      Name = "ALB Security Group"
    }
  )
}


#  Creating Target Group for ALB
resource "aws_lb_target_group" "tg" {
  name     = "aws-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    enabled             = true
    interval            = 30
    path                = "/"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  tags = merge(
    var.common_tags,
    {
      Name = "Target Group"
    }
  )
}

# Attaching Target Group to ALB
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

# Attaching Target Group to Auto Scaling Group
resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.app_asg.id
  lb_target_group_arn    = aws_lb_target_group.tg.arn
}
