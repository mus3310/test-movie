#!/bin/bash

# --- Unified, Context-Aware Script to Setup a New Service ---
# INSTRUCTIONS:
# 1. cd into the service directory you want to set up (e.g., cd /path/to/front-mymovies2)
# 2. Run this script from there: ../setup_project.sh

set -e # Exit immediately if a command exits with a non-zero status.

# --- Auto-detect paths and names ---
SERVICE_DIR=$(pwd)
SERVICE_NAME=$(basename "${SERVICE_DIR}")
PROJECT_ROOT=$(dirname "${SERVICE_DIR}")
K8S_DIR="${PROJECT_ROOT}/k8s"

# --- Check if running from a valid service directory ---
if [ ! -f "${SERVICE_DIR}/package.json" ] && [ ! -f "${SERVICE_DIR}/go.mod" ] && [ ! -f "${SERVICE_DIR}/pom.xml" ]; then
  echo "Warning: This does not look like a standard project directory."
  echo "Continuing anyway..."
fi
if [ ! -d "${K8S_DIR}" ]; then
    echo "Error: The 'k8s' directory was not found at '${K8S_DIR}'."
    echo "Please ensure you are running this script from a service directory within the main project."
    exit 1
fi

# --- Define K8s paths ---
BASE_DIR="${K8S_DIR}/base/${SERVICE_NAME}"
DEV_OVERLAY_DIR="${K8S_DIR}/overlays/dev"
PROD_OVERLAY_DIR="${K8S_DIR}/overlays/prod"
KUSTOMIZE_IMAGE_NAME="your-repo/${SERVICE_NAME}-image"


echo "--- Setting up service: ${SERVICE_NAME} ---"

# --- 1. Create CI/CD Files directly in the current service directory ---
echo "Creating CI/CD files in ${SERVICE_DIR}..."

# Create Dockerfile template
cat > "${SERVICE_DIR}/Dockerfile" << EOF
# Stage 1: Builder
# This is a template for a Node.js app. Please adapt for your specific project.
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build
RUN npm prune --production

# Stage 2: Runner
FROM node:18-alpine
WORKDIR /app
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/build ./build
COPY --from=builder /app/package.json ./
EXPOSE 3000
CMD [ "npm", "start" ]
EOF

# Create .gitlab-ci.yml template
cat > "${SERVICE_DIR}/.gitlab-ci.yml" << EOF
variables:
  SERVICE_NAME: "${SERVICE_NAME}"
  KUSTOMIZE_IMAGE_NAME: "${KUSTOMIZE_IMAGE_NAME}"
  K8S_DIR: "\${CI_PROJECT_DIR}/../k8s" # Path to k8s repo from service repo
  IMAGE_TAG: \$CI_REGISTRY_IMAGE:\$CI_COMMIT_SHORT_SHA

stages:
  - build
  - validate
  - deploy_dev
  - deploy_prod

.kubectl_template:
  image:
    name: bitnami/kubectl:latest
    entrypoint: [""]
  before_script:
    - kubectl config set-cluster meyacrew --server="\$EKS_SERVER" --certificate-authority="\$EKS_CA_CERT"
    - kubectl config set-credentials gitlab --token="\$EKS_GITLAB_TOKEN"
    - kubectl config set-context default --cluster=meyacrew --user=gitlab
    - kubectl config use-context default

build:
  stage: build
  image: docker:20.10.16
  services:
    - docker:20.10.16-dind
  before_script:
    - echo "\$CI_REGISTRY_PASSWORD" | docker login -u "\$CI_REGISTRY_USER" --password-stdin \$CI_REGISTRY
  script:
    - docker build -t \$IMAGE_TAG .
    - docker push \$IMAGE_TAG
  rules:
    - if: '\$CI_COMMIT_BRANCH == "deploy_development" || \$CI_COMMIT_BRANCH == "deploy_productions" || \$CI_COMMIT_TAG'

validate_kustomize:
  stage: validate
  extends: .kubectl_template
  script:
    - cd \${K8S_DIR}/overlays/dev
    - kubectl kustomize edit set image \$KUSTOMIZE_IMAGE_NAME=\$IMAGE_TAG
    - kubectl apply -k . --dry-run=client
    - cd ../prod
    - kubectl kustomize edit set image \$KUSTOMIZE_IMAGE_NAME=\$IMAGE_TAG
    - kubectl apply -k . --dry-run=client
  rules:
    - if: '\$CI_COMMIT_BRANCH == "deploy_development" || \$CI_COMMIT_BRANCH == "deploy_productions" || \$CI_COMMIT_TAG'

deploy_dev:
  stage: deploy_dev
  extends: .kubectl_template
  script:
    - cd \${K8S_DIR}/overlays/dev
    - kubectl kustomize edit set image \$KUSTOMIZE_IMAGE_NAME=\$IMAGE_TAG
    - kubectl apply -k .
  rules:
    - if: '\$CI_COMMIT_BRANCH == "deploy_development"'

deploy_prod:
  stage: deploy_prod
  extends: .kubectl_template
  script:
    - cd \${K8S_DIR}/overlays/prod
    - kubectl kustomize edit set image \$KUSTOMIZE_IMAGE_NAME=\$IMAGE_TAG
    - kubectl apply -k .
  rules:
    - if: '\$CI_COMMIT_BRANCH == "deploy_productions" || \$CI_COMMIT_TAG'
      when: manual
EOF

# --- 2. Create Kubernetes Manifests ---
echo "Creating Kubernetes manifests in ${K8S_DIR}..."
mkdir -p "${BASE_DIR}" "${DEV_OVERLAY_DIR}" "${PROD_OVERLAY_DIR}"

# Create base manifests
# ... (rest of the script is the same as before)
cat > "${BASE_DIR}/deployment.yaml" << EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ${SERVICE_NAME}
  namespace: app
spec:
  replicas: 1
  selector:
    matchLabels:
      app.kubernetes.io/name: ${SERVICE_NAME}
  template:
    metadata:
      labels:
        app.kubernetes.io/name: ${SERVICE_NAME}
    spec:
      containers:
        - name: ${SERVICE_NAME}
          image: ${KUSTOMIZE_IMAGE_NAME}:latest
          ports:
            - name: http
              containerPort: 3000
EOF

cat > "${BASE_DIR}/service.yaml" << EOF
apiVersion: v1
kind: Service
metadata:
  name: ${SERVICE_NAME}
  namespace: app
spec:
  type: ClusterIP
  selector:
    app.kubernetes.io/name: ${SERVICE_NAME}
  ports:
    - name: http
      port: 80
      targetPort: 3000
EOF

cat > "${BASE_DIR}/ingress.yaml" << EOF
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ${SERVICE_NAME}
  namespace: app
  annotations:
    kubernetes.io/ingress.class: kong
    cert-manager.io/cluster-issuer: letsencrypt-prod
spec:
  tls:
    - hosts:
        - ${SERVICE_NAME}.local
      secretName: ${SERVICE_NAME}-local-tls
  rules:
    - host: ${SERVICE_NAME}.local
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: ${SERVICE_NAME}
                port:
                  number: 80
EOF

cat > "${BASE_DIR}/kustomization.yaml" << EOF
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
namespace: app
resources:
  - deployment.yaml
  - service.yaml
  - ingress.yaml
EOF

# Create overlay patches
cat > "${DEV_OVERLAY_DIR}/${SERVICE_NAME}-deployment-patch.yaml" << EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ${SERVICE_NAME}
spec:
  template:
    spec:
      containers:
        - name: ${SERVICE_NAME}
          image: ${KUSTOMIZE_IMAGE_NAME}
EOF

cat > "${PROD_OVERLAY_DIR}/${SERVICE_NAME}-deployment-patch.yaml" << EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ${SERVICE_NAME}
spec:
  replicas: 2
  template:
    spec:
      containers:
        - name: ${SERVICE_NAME}
          image: ${KUSTOMIZE_IMAGE_NAME}
EOF

# --- 3. Update Main Kustomization Files ---
echo "Updating main kustomization files..."
# Update base kustomization
echo "- ./${SERVICE_NAME}" >> "${K8S_DIR}/base/kustomization.yaml"

# Update dev kustomization
yq e -i '.patches += [{"path": "'${SERVICE_NAME}'-deployment-patch.yaml", "target": {"kind": "Deployment", "name": "'${SERVICE_NAME}'}}]' "${DEV_OVERLAY_DIR}/kustomization.yaml"

# Update prod kustomization
yq e -i '.patches += [{"path": "'${SERVICE_NAME}'-deployment-patch.yaml", "target": {"kind": "Deployment", "name": "'${SERVICE_NAME}'}}]' "${PROD_OVERLAY_DIR}/kustomization.yaml"

echo "--- Successfully set up service: ${SERVICE_NAME} ---"
echo "NOTE: This script uses 'yq' to modify YAML files. Please install it if you haven't (brew install yq)."
echo "Review the generated files in '${SERVICE_DIR}' and '${K8S_DIR}' and commit them."