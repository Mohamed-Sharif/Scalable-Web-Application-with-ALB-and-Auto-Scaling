variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "ami_id" {
  description = "The ID of the AMI to use for the instances"
  type        = string
}

variable "instance_type" {
  description = "The type of instance to launch"
  type        = string
}

variable "private_subnets" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "security_group_id" {
  description = "The ID of the EC2 security group"
  type        = string
}

variable "iam_role_name" {
  description = "The name of the IAM role for EC2 instances"
  type        = string
}

variable "target_group_arns" {
  description = "List of target group ARNs"
  type        = list(string)
}

variable "user_data" {
  description = "The user data to provide when launching the instance"
  type        = string
}

variable "min_size" {
  description = "The minimum size of the Auto Scaling Group"
  type        = number
}

variable "max_size" {
  description = "The maximum size of the Auto Scaling Group"
  type        = number
}

variable "desired_capacity" {
  description = "The desired capacity of the Auto Scaling Group"
  type        = number
}

variable "sns_topic_arn" {
  description = "The ARN of the SNS topic for alarms"
  type        = string
  default     = ""
} 