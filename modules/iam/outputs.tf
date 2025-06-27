output "ec2_role_name" {
  description = "The name of the EC2 IAM role"
  value       = aws_iam_role.ec2_role.name
}

output "ec2_role_arn" {
  description = "The ARN of the EC2 IAM role"
  value       = aws_iam_role.ec2_role.arn
}

output "ec2_instance_profile_name" {
  description = "The name of the EC2 instance profile"
  value       = aws_iam_instance_profile.ec2_profile.name
}

output "ec2_instance_profile_arn" {
  description = "The ARN of the EC2 instance profile"
  value       = aws_iam_instance_profile.ec2_profile.arn
} 