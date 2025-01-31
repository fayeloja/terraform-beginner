resource "aws_launch_template" "main" {
  name_prefix   = "production-ec2"
  image_id      = "ami-0c02fb55956c7d316" # Replace with your AMI ID
  instance_type = "t2.micro"
  key_name      = "your-key-pair" # Replace with your key pair

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = var.security_groups
  }

  user_data = base64encode(<<-EOF
              #!/bin/bash
              echo "Hello, World!" > index.html
              nohup python -m SimpleHTTPServer 80 &
              EOF
              )
}

resource "aws_autoscaling_group" "main" {
  vpc_zone_identifier = var.private_subnets
  desired_capacity    = 2
  max_size            = 4
  min_size            = 1

  launch_template {
    id      = aws_launch_template.main.id
    version = "$Latest"
  }

  target_group_arns = [var.alb_target_group_arn]
}