#!/bin/bash
sudo -i
apt-get update -y
apt-get install -y mysql-client netcat-openbsd curl jq
apt-get update -y
TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
INSTANCE_ID=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id)
AZ=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/placement/availability-zone)
PRIVATE_IP=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/local-ipv4)

mkdir -p /var/log/app
cat <<EOF > /var/log/app/instance_info.txt
==================================================
PRIVATE BACKEND APPLICATION TIER
==================================================
Instance ID       : $INSTANCE_ID
Availability Zone : $AZ
Private IP        : $PRIVATE_IP
Status            : Active & Isolated
==================================================
EOF