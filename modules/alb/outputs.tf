output "alb_id" {
  description = "The ID of the Application Load Balancer"
  value       = aws_lb.main.id
}

output "alb_arn" {
  description = "The ARN of the Application Load Balancer"
  value       = aws_lb.main.arn
}

output "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer"
  value       = aws_lb.main.dns_name
}

output "alb_zone_id" {
  description = "The canonical hosted zone ID of the Application Load Balancer"
  value       = aws_lb.main.zone_id
}

output "target_group_arn" {
  description = "The ARN of the target group"
  value       = aws_lb_target_group.main.arn
}

output "target_group_name" {
  description = "The name of the target group"
  value       = aws_lb_target_group.main.name
}

output "listener_arn" {
  description = "The ARN of the ALB listener"
  value       = aws_lb_listener.main.arn
} 