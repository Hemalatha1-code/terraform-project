# VPC Output
output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}


# RDS Endpoint Output
output "rds_endpoint" {
  description = "RDS Connection Endpoint"
  value       = aws_db_instance.my_rds.endpoint
}
# 2. Load Balancer & Target Group Outputs
output "web_alb_dns" {
  description = "Public DNS name of the Main Application Load Balancer"
  value       = aws_lb.main_alb.dns_name
}

output "web_target_group_arn" {
  description = "ARN of the Public Web Target Group"
  value       = aws_lb_target_group.public_tg.arn
}

output "app_target_group_arn" {
  description = "ARN of the Private App Target Group"
  value       = aws_lb_target_group.private_tg.arn
}
# 3. Auto Scaling Group Outputs
output "web_asg_name" {
  description = "Name of the Public Web Auto Scaling Group"
  value       = aws_autoscaling_group.public_asg.name
}

output "app_asg_name" {
  description = "Name of the Private App Auto Scaling Group"
  value       = aws_autoscaling_group.private_asg.name
}
