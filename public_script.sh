#!/bin/bash
# Update packages and install Nginx + curl
sudo -i
apt-get update -y
apt-get install -y nginx curl
apt-get update -y
# Start and enable Nginx
systemctl start nginx
systemctl enable nginx

# Fetch EC2 Instance Metadata (IMDSv2)
TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
INSTANCE_ID=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id)
AZ=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/placement/availability-zone)
PRIVATE_IP=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/local-ipv4)

# Determine custom styling based on Availability Zone / Instance ID
if [[ "$AZ" == *"1a"* ]]; then
    THEME_COLOR="#38bdf8"
    SERVER_NAME="Web Node Alpha (AZ-1A)"
else
    THEME_COLOR="#a855f7"
    SERVER_NAME="Web Node Beta (AZ-1C)"
fi

# Create dynamic, custom styled HTML landing page
cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Multi-Tier Web Tier</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background-color: #0f172a;
            color: #f8fafc;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
        }
        .card {
            background-color: #1e293b;
            padding: 2.5rem;
            border-radius: 16px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.6);
            max-width: 500px;
            width: 90%;
            border: 1px solid #334155;
            position: relative;
            overflow: hidden;
        }
        .accent-bar {
            height: 6px;
            width: 100%;
            background-color: ${THEME_COLOR};
            position: absolute;
            top: 0;
            left: 0;
        }
        h1 {
            color: ${THEME_COLOR};
            font-size: 1.75rem;
            margin-top: 0.5rem;
            margin-bottom: 0.25rem;
        }
        .subtitle {
            color: #94a3b8;
            font-size: 0.9rem;
            margin-bottom: 1.5rem;
        }
        .status-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background-color: #064e3b;
            color: #34d399;
            padding: 0.3rem 0.8rem;
            border-radius: 9999px;
            font-size: 0.85rem;
            font-weight: 600;
        }
        .info-grid {
            display: grid;
            gap: 1rem;
            margin-top: 1.5rem;
        }
        .info-card {
            background-color: #0f172a;
            padding: 1rem;
            border-radius: 8px;
            border: 1px solid #1e293b;
        }
        .info-label {
            font-size: 0.75rem;
            color: #64748b;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }
        .info-value {
            font-size: 1rem;
            font-weight: 600;
            color: #f1f5f9;
            margin-top: 0.2rem;
            word-break: break-all;
        }
        .refresh-note {
            margin-top: 1.5rem;
            text-align: center;
            font-size: 0.8rem;
            color: #64748b;
        }
    </style>
</head>
<body>
    <div class="card">
        <div class="accent-bar"></div>
        <div class="status-badge">
            <span style="font-size: 1.2rem;">●</span> ALB Target Operational
        </div>
        <h1>${SERVER_NAME}</h1>
        <div class="subtitle">Multi-Tier Auto Scaled Web Tier</div>
        
        <div class="info-grid">
            <div class="info-card">
                <div class="info-label">Instance ID</div>
                <div class="info-value">${INSTANCE_ID}</div>
            </div>

            <div class="info-card">
                <div class="info-label">Availability Zone</div>
                <div class="info-value">${AZ}</div>
            </div>

            <div class="info-card">
                <div class="info-label">Private Internal IP</div>
                <div class="info-value">${PRIVATE_IP}</div>
            </div>
        </div>

        <div class="refresh-note">
            💡 Refresh your browser to see the Application Load Balancer route to the alternate node.
        </div>
    </div>
</body>
</html>
EOF

# Restart Nginx
systemctl restart nginx