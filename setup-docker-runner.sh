#!/bin/bash
# Script to install Docker on GitLab shell runner and configure it for container builds

set -euo pipefail

echo "=== Setting up Docker on GitLab Shell Runner ==="

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "This script must be run as root (use sudo)"
    exit 1
fi

# Detect OS
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
else
    echo "Cannot detect OS"
    exit 1
fi

echo "Detected OS: $OS"

# Install Docker based on OS
case $OS in
    ubuntu|debian)
        echo "Installing Docker on Ubuntu/Debian..."
        apt-get update
        apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
        apt-get update
        apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
        ;;
    centos|rhel|fedora)
        echo "Installing Docker on CentOS/RHEL/Fedora..."
        yum install -y yum-utils
        yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
        yum install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
        ;;
    amzn)
        echo "Installing Docker on Amazon Linux..."
        dnf update -y
        dnf install -y docker
        ;;
    alpine)
        echo "Installing Docker on Alpine..."
        apk add --no-cache docker docker-compose
        ;;
    *)
        echo "Unsupported OS: $OS"
        exit 1
        ;;
esac

# Start and enable Docker
echo "Starting Docker service..."
systemctl start docker
systemctl enable docker

# Add gitlab-runner user to docker group
echo "Adding gitlab-runner user to docker group..."
usermod -aG docker gitlab-runner

# Create docker-compose.yml for testing
echo "Creating test docker-compose.yml..."
cat > /tmp/test-docker.yml << 'EOF'
version: '3.8'
services:
  test:
    image: alpine:latest
    command: echo "Docker is working!"
EOF

# Test Docker installation
echo "Testing Docker installation..."
docker run --rm alpine:latest echo "Docker is working!"

# Test Docker Compose
echo "Testing Docker Compose..."
cd /tmp && docker-compose -f test-docker.yml up

# Clean up
rm -f /tmp/test-docker.yml

echo "=== Docker setup complete! ==="
echo "Docker version:"
docker --version
echo "Docker Compose version:"
docker-compose --version

echo ""
echo "=== Next Steps ==="
echo "1. Restart the GitLab runner service:"
echo "   sudo systemctl restart gitlab-runner"
echo ""
echo "2. Verify the runner can execute Docker commands:"
echo "   sudo -u gitlab-runner docker run --rm alpine:latest echo 'Test'"
echo ""
echo "3. Update your GitLab CI template to use the shell runner"
echo ""
echo "=== Setup Complete! ==="