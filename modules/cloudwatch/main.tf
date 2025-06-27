# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "application" {
  name              = "/aws/ec2/${var.project_name}-${var.environment}"
  retention_in_days = 7

  tags = {
    Name = "${var.project_name}-${var.environment}-log-group"
  }
}

# CloudWatch Dashboard
resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "${var.project_name}-${var.environment}-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6

        properties = {
          metrics = [
            ["AWS/EC2", "CPUUtilization", "AutoScalingGroupName", var.asg_name],
            [".", "NetworkIn", ".", "."],
            [".", "NetworkOut", ".", "."]
          ]
          period = 300
          stat   = "Average"
          region = "us-east-1"
          title  = "EC2 Metrics"
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6

        properties = {
          metrics = [
            ["AWS/ApplicationELB", "TargetResponseTime", "LoadBalancer", "app/${var.project_name}-${var.environment}-alb"],
            [".", "RequestCount", ".", "."],
            [".", "HealthyHostCount", ".", "."]
          ]
          period = 300
          stat   = "Average"
          region = "us-east-1"
          title  = "ALB Metrics"
        }
      },
      {
        type   = "log"
        x      = 0
        y      = 6
        width  = 24
        height = 6

        properties = {
          query   = "SOURCE '/aws/ec2/${var.project_name}-${var.environment}'\n| fields @timestamp, @message\n| sort @timestamp desc\n| limit 100"
          region  = "us-east-1"
          title   = "Application Logs"
          view    = "table"
        }
      }
    ]
  })
}

# CloudWatch Alarm for ALB 5XX errors
resource "aws_cloudwatch_metric_alarm" "alb_5xx" {
  alarm_name          = "${var.project_name}-${var.environment}-alb-5xx"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "HTTPCode_ELB_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = "300"
  statistic           = "Sum"
  threshold           = "10"
  alarm_description   = "This metric monitors ALB 5XX errors"
  alarm_actions       = [var.sns_topic_arn]

  dimensions = {
    LoadBalancer = "app/${var.project_name}-${var.environment}-alb"
  }
}

# CloudWatch Alarm for ALB 4XX errors
resource "aws_cloudwatch_metric_alarm" "alb_4xx" {
  alarm_name          = "${var.project_name}-${var.environment}-alb-4xx"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "HTTPCode_ELB_4XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = "300"
  statistic           = "Sum"
  threshold           = "50"
  alarm_description   = "This metric monitors ALB 4XX errors"
  alarm_actions       = [var.sns_topic_arn]

  dimensions = {
    LoadBalancer = "app/${var.project_name}-${var.environment}-alb"
  }
}

# CloudWatch Alarm for Target Response Time
resource "aws_cloudwatch_metric_alarm" "target_response_time" {
  alarm_name          = "${var.project_name}-${var.environment}-target-response-time"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "TargetResponseTime"
  namespace           = "AWS/ApplicationELB"
  period              = "300"
  statistic           = "Average"
  threshold           = "5"
  alarm_description   = "This metric monitors target response time"
  alarm_actions       = [var.sns_topic_arn]

  dimensions = {
    LoadBalancer = "app/${var.project_name}-${var.environment}-alb"
  }
} 