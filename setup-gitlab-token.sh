#!/bin/bash

# Script to set up GitLab CI/CD service account and extract token
# Run this script on a machine that has kubectl configured to access your EKS cluster

echo "=== Setting up GitLab CI/CD Service Account ==="

# Apply the service account configuration
echo "1. Applying service account configuration..."
kubectl apply -f k8s/gitlab-service-account.yaml

# Wait for the secret to be created
echo "2. Waiting for service account token to be created..."
sleep 10

# Extract the token
echo "3. Extracting service account token..."
TOKEN=$(kubectl get secret gitlab-ci-token -n default -o jsonpath='{.data.token}' | base64 -d)

if [ -z "$TOKEN" ]; then
    echo "ERROR: Failed to extract token. The secret might not be ready yet."
    echo "Please wait a few minutes and run this command manually:"
    echo "kubectl get secret gitlab-ci-token -n default -o jsonpath='{.data.token}' | base64 -d"
    exit 1
fi

echo "4. Token extracted successfully!"
echo ""
echo "=== NEXT STEPS ==="
echo "1. Copy the token below and set it as the EKS_GITLAB_TOKEN variable in GitLab:"
echo "   - Go to your GitLab project → Settings → CI/CD → Variables"
echo "   - Add/update variable: EKS_GITLAB_TOKEN"
echo "   - Set the value to the token shown below"
echo "   - Mark it as 'Masked' and 'Protected'"
echo ""
echo "TOKEN:"
echo "$TOKEN"
echo ""
echo "2. Also verify these variables are set in GitLab:"
echo "   - EKS_SERVER: Your EKS cluster endpoint URL"
echo "   - EKS_CA_CERT: Your EKS cluster certificate authority"
echo ""
echo "3. Test the connection by running your GitLab CI/CD pipeline"
echo ""
echo "=== VERIFICATION ==="
echo "You can test the token manually with:"
echo "kubectl --token=\"$TOKEN\" --server=\"YOUR_EKS_SERVER\" cluster-info"