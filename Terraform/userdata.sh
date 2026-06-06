#!/bin/bash
set -euxo pipefail

apt update
apt install -y docker.io cron curl jq

systemctl enable docker
systemctl start docker
systemctl enable cron
systemctl start cron

# Install Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | bash

cat << 'EOF' > /usr/local/bin/deploy.sh
#!/bin/bash
set -e

ACR_NAME="${acr_name}"
ACR_LOGIN="${acr_login}"
CONFIG_NAME="${config_name}"

CONTAINER_NAME="sample-app"
PORT=${app_port}

# Add user to docker group
usermod -aG docker azvmuser

# Wait for Docker
sleep 10

# Login using Managed Identity
az login --identity > /dev/null

# Get latest desired tag
TAG=$(az appconfig kv show \
  --name $CONFIG_NAME \
  --key latest-image-tag \
  --query value \
  -o tsv)

echo "Deploying version: $TAG"

# Login to ACR
az acr login --name $ACR_NAME

# Pull image
docker pull $ACR_LOGIN/app:$TAG

# Replace running container
docker stop $CONTAINER_NAME || true
docker rm $CONTAINER_NAME || true

docker run -d \
  --name $CONTAINER_NAME \
  --restart unless-stopped \
  -p $PORT:$PORT \
  $ACR_LOGIN/app:$TAG
EOF

chmod +x /usr/local/bin/deploy.sh


# Create systemd service
cat << 'EOF' > /etc/systemd/system/myapp.service
[Unit]
Description=My devops demo app
After=docker.service
Requires=docker.service

[Service]
ExecStart=/usr/local/bin/deploy.sh
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

# Create cron job
cat << 'EOF' > /etc/cron.d/myapp-deploy
    */5 * * * * root /usr/local/bin/deploy.sh >> /var/log/deploy.log 2>&1
EOF

# Correct permissions
chmod 644 /etc/cron.d/myapp-deploy

systemctl daemon-reload
systemctl enable --now myapp
