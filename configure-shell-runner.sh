#!/bin/bash

# Script to configure GitLab runner for shell executor only
# Run this on the GitLab runner server

set -euo pipefail

echo "🔧 Configuring GitLab runner for shell executor only..."

# Backup current config
sudo cp /etc/gitlab-runner/config.toml /etc/gitlab-runner/config.toml.backup.$(date +%Y%m%d_%H%M%S)

# Create new config for shell executor only
sudo tee /etc/gitlab-runner/config.toml > /dev/null << 'EOF'
concurrent = 1
check_interval = 0

[session_server]
  session_timeout = 1800

[[runners]]
  name = "ec2-ap-southeast-7-shell"
  url = "https://gitlab.meyacrew.com/"
  token = "REPLACE_WITH_YOUR_TOKEN"
  executor = "shell"
  shell = "bash"
  [runners.custom_build_dir]
  [runners.cache]
    [runners.cache.s3]
    [runners.cache.gcs]
    [runners.cache.azure]
EOF

echo "✅ Configuration created. Please:"
echo "1. Replace 'REPLACE_WITH_YOUR_TOKEN' with your actual runner token"
echo "2. Restart GitLab runner: sudo gitlab-runner restart"
echo "3. Verify configuration: sudo gitlab-runner verify"

echo ""
echo "🔍 To find your runner token:"
echo "1. Go to GitLab project → Settings → CI/CD → Runners"
echo "2. Copy the registration token"
echo "3. Or check the current config: sudo cat /etc/gitlab-runner/config.toml"