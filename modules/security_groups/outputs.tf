output "alb_sg_id" {
  description = "The ID of the ALB security group"
  value       = aws_security_group.alb.id
}

output "ec2_sg_id" {
  description = "The ID of the EC2 security group"
  value       = aws_security_group.ec2.id
}

output "alb_sg_name" {
  description = "The name of the ALB security group"
  value       = aws_security_group.alb.name
}

output "ec2_sg_name" {
  description = "The name of the EC2 security group"
  value       = aws_security_group.ec2.name
} 