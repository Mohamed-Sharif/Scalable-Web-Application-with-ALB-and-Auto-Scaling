# AWS Scalable Web Application with ALB and Auto Scaling

## 🚀 Project Overview

This project demonstrates a production-ready, scalable web application deployed on AWS using modern DevOps practices. The infrastructure is built using Terraform and includes a Python Flask application with high availability, auto-scaling, and comprehensive monitoring.

## 📋 Table of Contents

- [Architecture Overview](#architecture-overview)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Installation & Deployment](#installation--deployment)
- [Project Structure](#project-structure)
- [Configuration](#configuration)
- [Usage](#usage)
- [Monitoring & Alerting](#monitoring--alerting)
- [Security](#security)
- [Cost Optimization](#cost-optimization)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)

## 🏗️ Architecture Overview

### Solution Architecture Diagram

![Architecture Diagram](architecture-diagram.md)

The infrastructure consists of the following AWS services:

- **EC2 Instances**: Python Flask web application servers
- **Application Load Balancer (ALB)**: Traffic distribution and health checks
- **Auto Scaling Group (ASG)**: Automatic scaling based on demand
- **VPC with Public/Private Subnets**: Network isolation and security
- **CloudWatch**: Monitoring, logging, and alerting
- **SNS**: Email notifications for alarms
- **IAM**: Role-based access control

### Key Components

1. **Load Balancer**: Distributes incoming traffic across multiple EC2 instances
2. **Auto Scaling**: Automatically scales instances based on CPU utilization
3. **Health Checks**: Ensures only healthy instances receive traffic
4. **Multi-AZ Deployment**: High availability across availability zones
5. **Monitoring**: Real-time metrics and alerting

## ✨ Features

### Application Features
- 🐍 **Python Flask Web Application**: Modern, responsive web interface
- 🔍 **Health Check Endpoint**: `/health` for load balancer health checks
- 📊 **Instance Information API**: `/api/info` for instance details
- 📈 **Status Monitoring**: `/api/status` for application status
- 🎨 **Beautiful UI**: Modern, responsive design with gradient backgrounds

### Infrastructure Features
- 🔄 **Auto Scaling**: CPU-based scaling policies (80% threshold)
- 🌐 **Load Balancing**: Application Load Balancer with health checks
- 🛡️ **Security**: Security groups, IAM roles, and VPC isolation
- 📊 **Monitoring**: CloudWatch metrics, logs, and dashboards
- 📧 **Alerting**: SNS email notifications for critical events
- 🏗️ **Infrastructure as Code**: Complete Terraform configuration

### Scalability Features
- **Horizontal Scaling**: Add/remove instances based on demand
- **Load Distribution**: Traffic distributed across healthy instances
- **High Availability**: Multi-AZ deployment
- **Fault Tolerance**: Automatic failover and recovery

## 📋 Prerequisites

### Required Software
- **Terraform** >= 1.0
- **AWS CLI** configured with appropriate credentials
- **Python** 3.8+ (for local development)
- **Git** for version control

### AWS Requirements
- AWS Account with appropriate permissions
- AWS CLI configured with access keys
- Sufficient AWS service limits for:
  - EC2 instances (t3.micro)
  - Application Load Balancer
  - Auto Scaling Groups
  - CloudWatch metrics and logs

### Required AWS Permissions
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:*",
        "elasticloadbalancing:*",
        "autoscaling:*",
        "cloudwatch:*",
        "logs:*",
        "sns:*",
        "iam:*",
        "vpc:*"
      ],
      "Resource": "*"
    }
  ]
}
```

## 🚀 Installation & Deployment

### 1. Clone the Repository
```bash
git clone <repository-url>
cd mahara
```

### 2. Configure AWS Credentials
```bash
aws configure
# Enter your AWS Access Key ID
# Enter your AWS Secret Access Key
# Enter your default region (e.g., us-east-1)
```

### 3. Customize Configuration (Optional)
Edit `variables.tf` to customize:
- AWS region
- Instance type
- Auto scaling parameters
- Email for notifications

### 4. Initialize Terraform
```bash
terraform init
```

### 5. Plan the Deployment
```bash
terraform plan
```

### 6. Deploy the Infrastructure
```bash
terraform apply
```

### 7. Access the Application
After deployment, Terraform will output the ALB URL:
```bash
terraform output alb_url
```

## 📁 Project Structure

```
mahara/
├── app.py                          # Flask web application
├── requirements.txt                # Python dependencies
├── user_data.sh                    # EC2 instance setup script
├── main.tf                         # Main Terraform configuration
├── variables.tf                    # Terraform variables
├── architecture-diagram.md         # Solution architecture diagram
├── README.md                       # This file
└── modules/                        # Terraform modules
    ├── vpc/                        # VPC and networking
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── security_groups/            # Security group definitions
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── iam/                        # IAM roles and policies
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── alb/                        # Application Load Balancer
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── asg/                        # Auto Scaling Group
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── cloudwatch/                 # Monitoring and alerting
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    └── sns/                        # SNS notifications
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

## ⚙️ Configuration

### Environment Variables
The application uses the following environment variables:
- `ENVIRONMENT`: Production/Development
- `AWS_REGION`: AWS region
- `INSTANCE_ID`: EC2 instance ID
- `PORT`: Application port (default: 5000)

### Terraform Variables
Key variables you can customize in `variables.tf`:

| Variable | Description | Default |
|----------|-------------|---------|
| `aws_region` | AWS region | `us-east-1` |
| `instance_type` | EC2 instance type | `t3.micro` |
| `asg_min_size` | Minimum ASG size | `2` |
| `asg_max_size` | Maximum ASG size | `4` |
| `asg_desired_capacity` | Desired ASG capacity | `2` |
| `alert_email` | Email for notifications | `ms2036@fayoum.edu.eg` |

### Scaling Configuration
- **CPU Threshold**: 80% for scale up, 20% for scale down
- **Cooldown Period**: 300 seconds between scaling actions
- **Health Check**: 30-second intervals with 5-second timeout

## 🎯 Usage

### Accessing the Application
1. Get the ALB URL from Terraform outputs
2. Open the URL in your web browser
3. The application will display instance information and AWS services used

### API Endpoints
- `GET /`: Main application page
- `GET /health`: Health check endpoint (returns JSON)
- `GET /api/info`: Instance information API
- `GET /api/status`: Application status API

### Testing Auto Scaling
1. **Scale Up**: Generate load to increase CPU above 80%
2. **Scale Down**: Reduce load to decrease CPU below 20%
3. **Monitor**: Check CloudWatch metrics and ASG events

### Load Testing
```bash
# Install Apache Bench
sudo apt-get install apache2-utils

# Generate load (adjust URL and parameters)
ab -n 1000 -c 10 http://your-alb-url/
```

## 📊 Monitoring & Alerting

### CloudWatch Dashboard
Access the CloudWatch dashboard to monitor:
- EC2 CPU and memory utilization
- ALB request count and response time
- Application logs
- Auto scaling events

### CloudWatch Alarms
The following alarms are configured:
- **High CPU**: > 80% for 2 evaluation periods
- **Low CPU**: < 20% for 2 evaluation periods
- **High Memory**: > 80% for 2 evaluation periods
- **ALB 5XX Errors**: > 10 errors in 5 minutes
- **ALB 4XX Errors**: > 50 errors in 5 minutes
- **Target Response Time**: > 5 seconds average

### SNS Notifications
Email notifications are sent for:
- Auto scaling events
- CloudWatch alarms
- System health issues

### Log Monitoring
- **Application Logs**: `/var/log/aws-webapp.log`
- **CloudWatch Logs**: `/aws/ec2/webapp`
- **System Logs**: Standard Linux system logs

## 🔒 Security

### Network Security
- **VPC Isolation**: Complete network isolation
- **Private Subnets**: EC2 instances in private subnets
- **Security Groups**: Restrictive firewall rules
- **NAT Gateway**: Outbound internet access for private instances

### Access Control
- **IAM Roles**: Least privilege access for EC2 instances
- **Security Groups**: Port-specific access rules
- **No Public IPs**: EC2 instances don't have public IPs

### Security Best Practices
- ✅ Multi-AZ deployment for high availability
- ✅ Private subnets for application servers
- ✅ Security groups with minimal required access
- ✅ IAM roles with least privilege
- ✅ CloudWatch monitoring and alerting
- ✅ Automated health checks

## 💰 Cost Optimization

### Current Configuration
- **Instance Type**: t3.micro (burstable, cost-effective)
- **Auto Scaling**: Scale down during low traffic
- **Multi-AZ**: Only 2 availability zones

### Cost Optimization Strategies
1. **Reserved Instances**: Purchase RI for predictable workloads
2. **Spot Instances**: Use spot instances for non-critical workloads
3. **Right-sizing**: Monitor and adjust instance types
4. **Scheduled Scaling**: Scale down during off-hours
5. **Cost Monitoring**: Set up billing alerts

### Estimated Monthly Costs (us-east-1)
- **t3.micro instances**: ~$8.47/month each
- **ALB**: ~$16.20/month
- **NAT Gateway**: ~$45.00/month
- **CloudWatch**: ~$5.00/month
- **Total**: ~$83.14/month (2 instances)

## 🛠️ Troubleshooting

### Common Issues

#### Application Not Accessible
1. Check ALB health status
2. Verify security group rules
3. Check EC2 instance health
4. Review application logs

#### Auto Scaling Not Working
1. Check CloudWatch alarms
2. Verify scaling policies
3. Review ASG configuration
4. Check instance health checks

#### High Response Times
1. Monitor CPU and memory usage
2. Check if scaling is needed
3. Review application performance
4. Check network connectivity

### Debugging Commands

#### Check Instance Status
```bash
# SSH into instance (if needed)
ssh -i your-key.pem ec2-user@instance-ip

# Check application status
sudo systemctl status aws-webapp

# Check application logs
sudo journalctl -u aws-webapp -f

# Check CloudWatch agent
sudo systemctl status amazon-cloudwatch-agent
```

#### Check ALB Health
```bash
# Test health endpoint
curl http://your-alb-url/health

# Check target group health
aws elbv2 describe-target-health \
  --target-group-arn your-target-group-arn
```

#### Check Auto Scaling
```bash
# List ASG activities
aws autoscaling describe-scaling-activities \
  --auto-scaling-group-name your-asg-name

# Check ASG instances
aws autoscaling describe-auto-scaling-groups \
  --auto-scaling-group-names your-asg-name
```

### Log Locations
- **Application Logs**: `/var/log/aws-webapp.log`
- **System Logs**: `/var/log/messages`
- **CloudWatch Agent**: `/opt/aws/amazon-cloudwatch-agent/logs/`

## 🔄 Maintenance

### Regular Tasks
1. **Security Updates**: Keep AMI updated
2. **Terraform Updates**: Update Terraform and provider versions
3. **Monitoring Review**: Review and adjust CloudWatch alarms
4. **Cost Review**: Monitor and optimize costs
5. **Backup**: Ensure data backup if applicable

### Scaling Considerations
- Monitor application performance
- Adjust scaling thresholds as needed
- Consider predictive scaling for known patterns
- Review and optimize instance types

## 🤝 Contributing

### Development Setup
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

### Testing
- Test locally with `python app.py`
- Validate Terraform configuration
- Test auto scaling functionality
- Verify monitoring and alerting

### Code Standards
- Follow Python PEP 8 guidelines
- Use meaningful variable names
- Add comments for complex logic
- Update documentation for changes

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- AWS for providing the cloud infrastructure
- HashiCorp for Terraform
- Python Flask community
- Open source contributors

## 📞 Support

For support and questions:
- Create an issue in the repository
- Check the troubleshooting section
- Review AWS documentation
- Contact the development team

---

**Note**: This is a demonstration project. For production use, consider additional security measures, backup strategies, and compliance requirements. 
