#!/bin/bash
set -e
exec > >(tee /var/log/user-data.log) 2>&1

echo "=== STARTING DEPLOYMENT ==="

# Install Docker
if ! command -v docker &>/dev/null; then
    amazon-linux-extras install docker -y
    systemctl enable docker
    systemctl start docker
    usermod -aG docker ec2-user
fi

# Mount EBS
mkdir -p /app
if ! blkid /dev/xvdk; then
    mkfs -t ext4 /dev/xvdk
fi
mount /dev/xvdk /app
echo '/dev/xvdk /app ext4 defaults,nofail 0 2' >> /etc/fstab

# Docker-Compose
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" \
    -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Deploy App
cat << 'EOF' > /app/Dockerfile
FROM python:3.9-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY app.py .
USER 1000:1000
EXPOSE 8081
CMD ["python", "app.py"]
EOF

cat << 'EOF' > /app/app.py
from flask import Flask, jsonify
import random
app = Flask(__name__)
STRINGS = ["Investments", "Smallcase", "Stocks", "buy-the-dip", "TickerTape"]
@app.route('/api/v1', methods=['GET'])
def get_random_string():
    return jsonify({"result": random.choice(STRINGS), "status": "success"})
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8081)
EOF

cat << 'EOF' > /app/requirements.txt
flask>=2.0.0
werkzeug>=2.0.0,<3.0.0
EOF

# Build and Run
cd /app
docker build -t python-app .
docker run -d \
    --name python-app \
    --restart unless-stopped \
    -p 8081:8081 \
    -v /app:/app \
    python-app

echo "=== DEPLOYMENT COMPLETE ==="