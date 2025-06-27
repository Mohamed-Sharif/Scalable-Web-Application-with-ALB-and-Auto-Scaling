#!/bin/bash

# AWS Scalable Web Application Deployment Script
# This script automates the deployment of the infrastructure using Terraform

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check prerequisites
check_prerequisites() {
    print_status "Checking prerequisites..."
    
    # Check if Terraform is installed
    if ! command_exists terraform; then
        print_error "Terraform is not installed. Please install Terraform >= 1.0"
        exit 1
    fi
    
    # Check Terraform version
    TF_VERSION=$(terraform version -json | jq -r '.terraform_version')
    print_status "Terraform version: $TF_VERSION"
    
    # Check if AWS CLI is installed
    if ! command_exists aws; then
        print_error "AWS CLI is not installed. Please install AWS CLI"
        exit 1
    fi
    
    # Check if AWS credentials are configured
    if ! aws sts get-caller-identity >/dev/null 2>&1; then
        print_error "AWS credentials are not configured. Please run 'aws configure'"
        exit 1
    fi
    
    # Check if jq is installed (for JSON parsing)
    if ! command_exists jq; then
        print_warning "jq is not installed. Some features may not work properly."
    fi
    
    print_success "Prerequisites check completed"
}

# Function to validate configuration
validate_configuration() {
    print_status "Validating configuration..."
    
    # Check if terraform.tfvars exists
    if [ ! -f "terraform.tfvars" ]; then
        print_warning "terraform.tfvars not found. Using default values."
        print_status "You can copy terraform.tfvars.example to terraform.tfvars and customize it."
    fi
    
    # Validate required files exist
    required_files=("main.tf" "variables.tf" "user_data.sh")
    for file in "${required_files[@]}"; do
        if [ ! -f "$file" ]; then
            print_error "Required file $file not found"
            exit 1
        fi
    done
    
    print_success "Configuration validation completed"
}

# Function to initialize Terraform
initialize_terraform() {
    print_status "Initializing Terraform..."
    
    if terraform init; then
        print_success "Terraform initialized successfully"
    else
        print_error "Failed to initialize Terraform"
        exit 1
    fi
}

# Function to plan Terraform deployment
plan_deployment() {
    print_status "Planning Terraform deployment..."
    
    if terraform plan -out=tfplan; then
        print_success "Terraform plan completed successfully"
    else
        print_error "Failed to create Terraform plan"
        exit 1
    fi
}

# Function to apply Terraform deployment
apply_deployment() {
    print_status "Applying Terraform deployment..."
    
    if terraform apply tfplan; then
        print_success "Terraform deployment completed successfully"
    else
        print_error "Failed to apply Terraform deployment"
        exit 1
    fi
}

# Function to display deployment information
display_deployment_info() {
    print_status "Retrieving deployment information..."
    
    echo ""
    echo "=========================================="
    echo "🚀 DEPLOYMENT COMPLETED SUCCESSFULLY! 🚀"
    echo "=========================================="
    echo ""
    
    # Get ALB URL
    ALB_URL=$(terraform output -raw alb_url 2>/dev/null || echo "Not available")
    echo "🌐 Application URL: $ALB_URL"
    
    # Get ASG name
    ASG_NAME=$(terraform output -raw asg_name 2>/dev/null || echo "Not available")
    echo "🔄 Auto Scaling Group: $ASG_NAME"
    
    # Get VPC ID
    VPC_ID=$(terraform output -raw vpc_id 2>/dev/null || echo "Not available")
    echo "🏢 VPC ID: $VPC_ID"
    
    # Get CloudWatch dashboard
    DASHBOARD_NAME=$(terraform output -raw cloudwatch_dashboard_name 2>/dev/null || echo "Not available")
    echo "📊 CloudWatch Dashboard: $DASHBOARD_NAME"
    
    echo ""
    echo "📋 Next Steps:"
    echo "1. Access your application at: $ALB_URL"
    echo "2. Monitor your infrastructure in the AWS Console"
    echo "3. Check CloudWatch for metrics and logs"
    echo "4. Test auto-scaling by generating load"
    echo ""
    echo "📚 Documentation: README.md"
    echo "🔧 To destroy infrastructure: terraform destroy"
    echo ""
}

# Function to cleanup
cleanup() {
    print_status "Cleaning up temporary files..."
    rm -f tfplan
    print_success "Cleanup completed"
}

# Main deployment function
main() {
    echo ""
    echo "=========================================="
    echo "🚀 AWS Scalable Web Application Deployment"
    echo "=========================================="
    echo ""
    
    # Check prerequisites
    check_prerequisites
    
    # Validate configuration
    validate_configuration
    
    # Initialize Terraform
    initialize_terraform
    
    # Plan deployment
    plan_deployment
    
    # Ask for confirmation
    echo ""
    read -p "Do you want to proceed with the deployment? (y/N): " -n 1 -r
    echo ""
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # Apply deployment
        apply_deployment
        
        # Display deployment information
        display_deployment_info
        
        # Cleanup
        cleanup
        
        print_success "Deployment completed successfully!"
    else
        print_warning "Deployment cancelled by user"
        cleanup
        exit 0
    fi
}

# Function to show usage
show_usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -h, --help     Show this help message"
    echo "  --plan-only    Only run terraform plan (don't apply)"
    echo "  --destroy      Destroy the infrastructure"
    echo ""
    echo "Examples:"
    echo "  $0              # Full deployment"
    echo "  $0 --plan-only  # Only plan the deployment"
    echo "  $0 --destroy    # Destroy the infrastructure"
}

# Function to destroy infrastructure
destroy_infrastructure() {
    print_status "Destroying infrastructure..."
    
    if terraform destroy -auto-approve; then
        print_success "Infrastructure destroyed successfully"
    else
        print_error "Failed to destroy infrastructure"
        exit 1
    fi
}

# Parse command line arguments
case "${1:-}" in
    -h|--help)
        show_usage
        exit 0
        ;;
    --plan-only)
        check_prerequisites
        validate_configuration
        initialize_terraform
        plan_deployment
        print_success "Plan completed. Run without --plan-only to apply."
        exit 0
        ;;
    --destroy)
        check_prerequisites
        initialize_terraform
        destroy_infrastructure
        exit 0
        ;;
    "")
        main
        ;;
    *)
        print_error "Unknown option: $1"
        show_usage
        exit 1
        ;;
esac 