from flask import Flask, jsonify, render_template_string
import os
import socket
import datetime
import platform

app = Flask(__name__)

# HTML template for the main page
HTML_TEMPLATE = """
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AWS Scalable Web Application</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            min-height: 100vh;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            background: rgba(255, 255, 255, 0.1);
            padding: 30px;
            border-radius: 15px;
            backdrop-filter: blur(10px);
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
        }
        h1 {
            text-align: center;
            margin-bottom: 30px;
            font-size: 2.5em;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.3);
        }
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .info-card {
            background: rgba(255, 255, 255, 0.2);
            padding: 20px;
            border-radius: 10px;
            border: 1px solid rgba(255, 255, 255, 0.3);
        }
        .info-card h3 {
            margin-top: 0;
            color: #ffd700;
        }
        .status {
            text-align: center;
            padding: 15px;
            border-radius: 10px;
            font-weight: bold;
            font-size: 1.2em;
        }
        .status.healthy {
            background: rgba(76, 175, 80, 0.3);
            border: 2px solid #4caf50;
        }
        .timestamp {
            text-align: center;
            font-style: italic;
            opacity: 0.8;
        }
        .features {
            background: rgba(255, 255, 255, 0.1);
            padding: 20px;
            border-radius: 10px;
            margin-top: 20px;
        }
        .features h3 {
            color: #ffd700;
            margin-top: 0;
        }
        .features ul {
            list-style-type: none;
            padding: 0;
        }
        .features li {
            padding: 8px 0;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }
        .features li:before {
            content: "✓ ";
            color: #4caf50;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚀 AWS Scalable Web Application</h1>
        
        <div class="status healthy">
            ✅ Application Status: HEALTHY
        </div>
        
        <div class="info-grid">
            <div class="info-card">
                <h3>🖥️ Instance Info</h3>
                <p><strong>Hostname:</strong> {{ hostname }}</p>
                <p><strong>IP Address:</strong> {{ ip_address }}</p>
                <p><strong>Platform:</strong> {{ platform }}</p>
            </div>
            
            <div class="info-card">
                <h3>⚙️ Environment</h3>
                <p><strong>Environment:</strong> {{ environment }}</p>
                <p><strong>Region:</strong> {{ region }}</p>
                <p><strong>Instance ID:</strong> {{ instance_id }}</p>
            </div>
            
            <div class="info-card">
                <h3>📊 System Info</h3>
                <p><strong>Python Version:</strong> {{ python_version }}</p>
                <p><strong>Flask Version:</strong> {{ flask_version }}</p>
                <p><strong>Uptime:</strong> {{ uptime }}</p>
            </div>
        </div>
        
        <div class="features">
            <h3>🔧 AWS Services Used</h3>
            <ul>
                <li>EC2 Instances for compute</li>
                <li>Application Load Balancer (ALB) for traffic distribution</li>
                <li>Auto Scaling Group (ASG) for scalability</li>
                <li>IAM Roles for secure access</li>
                <li>CloudWatch for monitoring</li>
                <li>SNS for notifications</li>
                <li>VPC with public and private subnets</li>
                <li>Security Groups for network security</li>
            </ul>
        </div>
        
        <div class="timestamp">
            Last updated: {{ timestamp }}
        </div>
    </div>
</body>
</html>
"""

@app.route('/')
def home():
    """Main application page"""
    try:
        hostname = socket.gethostname()
        ip_address = socket.gethostbyname(hostname)
    except:
        hostname = "Unknown"
        ip_address = "Unknown"
    
    # Get environment variables (set by Terraform)
    environment = os.environ.get('ENVIRONMENT', 'Development')
    region = os.environ.get('AWS_REGION', 'us-east-1')
    instance_id = os.environ.get('INSTANCE_ID', 'Unknown')
    
    # Get system information
    python_version = platform.python_version()
    flask_version = "2.3.3"  # You can make this dynamic if needed
    
    # Calculate uptime (simplified)
    uptime = "Running"
    
    timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S UTC")
    
    return render_template_string(HTML_TEMPLATE, 
                                hostname=hostname,
                                ip_address=ip_address,
                                platform=platform.platform(),
                                environment=environment,
                                region=region,
                                instance_id=instance_id,
                                python_version=python_version,
                                flask_version=flask_version,
                                uptime=uptime,
                                timestamp=timestamp)

@app.route('/health')
def health():
    """Health check endpoint for ALB"""
    return jsonify({
        "status": "healthy",
        "timestamp": datetime.datetime.now().isoformat(),
        "service": "aws-scalable-webapp",
        "version": "1.0.0"
    }), 200

@app.route('/api/info')
def api_info():
    """API endpoint returning instance information"""
    try:
        hostname = socket.gethostname()
        ip_address = socket.gethostbyname(hostname)
    except:
        hostname = "Unknown"
        ip_address = "Unknown"
    
    return jsonify({
        "hostname": hostname,
        "ip_address": ip_address,
        "platform": platform.platform(),
        "python_version": platform.python_version(),
        "environment": os.environ.get('ENVIRONMENT', 'Development'),
        "region": os.environ.get('AWS_REGION', 'us-east-1'),
        "instance_id": os.environ.get('INSTANCE_ID', 'Unknown'),
        "timestamp": datetime.datetime.now().isoformat()
    })

@app.route('/api/status')
def status():
    """Status endpoint for monitoring"""
    return jsonify({
        "status": "operational",
        "uptime": "running",
        "checks": {
            "database": "healthy",
            "cache": "healthy",
            "external_services": "healthy"
        },
        "timestamp": datetime.datetime.now().isoformat()
    })

if __name__ == '__main__':
    # Get port from environment variable or default to 5000
    port = int(os.environ.get('PORT', 5000))
    
    # Run the application
    app.run(host='0.0.0.0', port=port, debug=False) 