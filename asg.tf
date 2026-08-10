# ===================================================================
# 1. PUBLIC AUTO SCALING GROUP (Web Tier)
# ===================================================================
resource "aws_launch_template" "public_asg_template" {
  name_prefix   = "public-app-template-"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = "hema-vmr"

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.ec2_sg.id]
  }

  user_data = base64encode(file("public_script.sh"))

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "Public-Web-Instance"
    }
  }
}

resource "aws_autoscaling_group" "public_asg" {
  name = "public-web-asg"

  vpc_zone_identifier = [
    aws_subnet.public_1.id,
    aws_subnet.public_2.id
  ]

  target_group_arns = [
    aws_lb_target_group.public_tg.arn
  ]

  min_size         = 2
  max_size         = 4
  desired_capacity = 2

  health_check_type         = "ELB"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.public_asg_template.id
    version = "$Latest"
  }
}

# ===================================================================
# 2. PRIVATE AUTO SCALING GROUP (App Tier)
# ===================================================================
resource "aws_launch_template" "private_asg_template" {
  name_prefix   = "private-app-template-"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = "hema-vmr"

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.ec2_sg.id]
  }

  user_data = base64encode(file("private_script.sh"))

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "Private-App-Instance"
    }
  }
}

resource "aws_autoscaling_group" "private_asg" {
  name = "private-app-asg"

  vpc_zone_identifier = [
    aws_subnet.private_1.id,
    aws_subnet.private_2.id
  ]

  min_size         = 2
  max_size         = 4
  desired_capacity = 2

  health_check_type         = "EC2"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.private_asg_template.id
    version = "$Latest"
  }

  depends_on = [aws_db_instance.my_rds]
}