# SNS Topic
resource "aws_sns_topic" "main" {
  name = "${var.project_name}-${var.environment}-alerts"

  tags = {
    Name = "${var.project_name}-${var.environment}-sns-topic"
  }
}

# SNS Topic Policy
resource "aws_sns_topic_policy" "main" {
  arn = aws_sns_topic.main.arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "cloudwatch.amazonaws.com"
        }
        Action   = "SNS:Publish"
        Resource = aws_sns_topic.main.arn
      }
    ]
  })
}

# SNS Subscription
resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.main.arn
  protocol  = "email"
  endpoint  = var.email
} 