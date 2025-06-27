# Configure the AWS Provider
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  
  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
      Owner       = var.owner
    }
  }
}

# Data sources
data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# VPC Module
module "vpc" {
  source = "./modules/vpc"
  
  project_name    = var.project_name
  environment     = var.environment
  vpc_cidr        = var.vpc_cidr
  azs             = data.aws_availability_zones.available.names
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
}

# Security Groups Module
module "security_groups" {
  source = "./modules/security_groups"
  
  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.vpc.vpc_id
}

# IAM Module
module "iam" {
  source = "./modules/iam"
  
  project_name = var.project_name
  environment  = var.environment
}

# Application Load Balancer Module
module "alb" {
  source = "./modules/alb"
  
  project_name     = var.project_name
  environment      = var.environment
  vpc_id           = module.vpc.vpc_id
  public_subnets   = module.vpc.public_subnets
  security_group_id = module.security_groups.alb_sg_id
}

# SNS Module
module "sns" {
  source = "./modules/sns"
  
  project_name = var.project_name
  environment  = var.environment
  email        = var.alert_email
}

# Auto Scaling Group Module
module "asg" {
  source = "./modules/asg"
  
  project_name      = var.project_name
  environment       = var.environment
  ami_id            = data.aws_ami.amazon_linux_2.id
  instance_type     = var.instance_type
  private_subnets   = module.vpc.private_subnets
  security_group_id = module.security_groups.ec2_sg_id
  iam_role_name     = module.iam.ec2_instance_profile_name
  target_group_arns = [module.alb.target_group_arn]
  user_data         = base64encode(file("${path.module}/user_data.sh"))
  min_size          = var.asg_min_size
  max_size          = var.asg_max_size
  desired_capacity  = var.asg_desired_capacity
  sns_topic_arn     = module.sns.sns_topic_arn
}

# CloudWatch Module
module "cloudwatch" {
  source = "./modules/cloudwatch"
  
  project_name = var.project_name
  environment  = var.environment
  asg_name     = module.asg.asg_name
  sns_topic_arn = module.sns.sns_topic_arn
}

# Outputs
output "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer"
  value       = module.alb.alb_dns_name
}

output "alb_url" {
  description = "The URL of the Application Load Balancer"
  value       = "http://${module.alb.alb_dns_name}"
}

output "asg_name" {
  description = "The name of the Auto Scaling Group"
  value       = module.asg.asg_name
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "private_subnets" {
  description = "The IDs of the private subnets"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "The IDs of the public subnets"
  value       = module.vpc.public_subnets
}

output "sns_topic_arn" {
  description = "The ARN of the SNS topic"
  value       = module.sns.sns_topic_arn
}

output "cloudwatch_dashboard_name" {
  description = "The name of the CloudWatch dashboard"
  value       = module.cloudwatch.dashboard_name
} 