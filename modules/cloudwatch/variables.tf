variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "asg_name" {
  description = "The name of the Auto Scaling Group"
  type        = string
}

variable "sns_topic_arn" {
  description = "The ARN of the SNS topic for alarms"
  type        = string
  default     = ""
} 