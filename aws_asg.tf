#  Creating Launch Template
resource "aws_launch_template" "app_lt" {
  name          = "app-launch-template"
  image_id      = var.ami_id
  instance_type = var.instance_type
  user_data     = base64encode(file("${path.module}/setup.sh")) # Setup script for web server

  vpc_security_group_ids = [aws_security_group.instance_sg.id]

  tag_specifications {
    resource_type = "instance"
    tags = merge(
      var.common_tags,
      {
        Name = "Instance Template"
      }
    )
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "instance_sg" {
  name        = "instance-security-group"
  description = "Security group for instances"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
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
      Name = "Instance Security Group"
    }
  )
}

# Creating Auto Scaling Group
resource "aws_autoscaling_group" "app_asg" {

  launch_template {
    id      = aws_launch_template.app_lt.id
    version = "$Latest"
  }
  name                = "app-asg"
  min_size            = 1
  max_size            = 4
  desired_capacity    = 2
  vpc_zone_identifier = aws_subnet.private_subnet.*.id

  tag {
    key                 = "Name"
    value               = "app-instance-${formatdate("YYYYMMDDHHmmss", timestamp())}"
    propagate_at_launch = true
  }
}
