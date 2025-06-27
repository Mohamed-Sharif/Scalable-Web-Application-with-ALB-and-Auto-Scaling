output "asg_name" {
  description = "The name of the Auto Scaling Group"
  value       = aws_autoscaling_group.main.name
}

output "asg_arn" {
  description = "The ARN of the Auto Scaling Group"
  value       = aws_autoscaling_group.main.arn
}

output "launch_template_id" {
  description = "The ID of the launch template"
  value       = aws_launch_template.main.id
}

output "launch_template_name" {
  description = "The name of the launch template"
  value       = aws_launch_template.main.name
}

output "scale_up_policy_arn" {
  description = "The ARN of the scale up policy"
  value       = aws_autoscaling_policy.scale_up.arn
}

output "scale_down_policy_arn" {
  description = "The ARN of the scale down policy"
  value       = aws_autoscaling_policy.scale_down.arn
} 