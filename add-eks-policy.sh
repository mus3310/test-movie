#!/bin/bash

# Add EKS Cluster Admin Policy to gitlab-ci-s3-user
aws eks create-access-entry \
  --cluster-name meyacrew \
  --principal-arn arn:aws:iam::517065019659:user/gitlab-ci-s3-user \
  --region ap-southeast-7

# Associate the policy
aws eks associate-access-policy \
  --cluster-name meyacrew \
  --principal-arn arn:aws:iam::517065019659:user/gitlab-ci-s3-user \
  --policy-arn arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy \
  --access-scope type=cluster \
  --region ap-southeast-7

echo "EKS Cluster Admin Policy added successfully!"
