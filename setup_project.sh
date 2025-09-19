#!/bin/bash

# --- Standalone, Interactive Script with SSH Auth to Setup a New Service (v3) ---
# INSTRUCTIONS:
# 1. Copy this script into the root of the new service you want to set up.
# 2. cd into that directory.
# 3. Make the script executable: chmod +x setup_service.sh
# 4. Run it: ./setup_service.sh

set -e # Exit immediately if a command exits with a non-zero status.

# --- Auto-detect paths and names ---
SERVICE_DIR=$(pwd)
SERVICE_NAME=$(basename "${SERVICE_DIR}")

echo "--- Setting up service: ${SERVICE_NAME} ---"
echo

# --- Interactive Prompts for Configuration ---
read -p "Enter Node.js version [default: 20]: " NODE_VERSION
NODE_VERSION=${NODE_VERSION:-20}

while true; do
  read -p "Enter package manager (npm, pnpm, bun, yarn) [default: npm]: " PKG_MANAGER
  PKG_MANAGER=${PKG_MANAGER:-npm}
  case ${PKG_MANAGER} in
    npm|pnpm|bun|yarn)
      break
      ;;
    *)
      echo "Invalid input. Please choose one of: npm, pnpm, bun, yarn."
      ;;
  esac
done

while true; do
  read -p "Enter the full URL of your k8s repository (e.g., https://gitlab.meyacrew.com/my-movies/k8s): " K8S_REPO_URL
  if [ -n "$K8S_REPO_URL" ]; then
    break
  else
    echo "This field is required."
  fi
done

while true; do
  read -p "Enter your GitLab Deploy Token Username for the k8s repo: " GITLAB_DEPLOY_USER
  if [ -n "$GITLAB_DEPLOY_USER" ]; then
    break
  fi
done

while true; do
  read -sp "Enter your GitLab Deploy Token Password for the k8s repo: " GITLAB_DEPLOY_TOKEN
  echo
  if [ -n "$GITLAB_DEPLOY_TOKEN" ]; then
    break
  fi
done

# --- Parse URL and Define Paths ---
CLEAN_URL=$(echo "$K8S_REPO_URL" | sed -e 's/\/$//' -e 's/\.git$//')
K8S_REPO_HOST=$(echo "$CLEAN_URL" | sed -E 's|https?://([^/]+)/.*|\1|')
K8S_REPO_PATH=$(echo "$CLEAN_URL" | sed -E 's|https?://[^/]+/(.*)|\1|')
TEMP_K8S_DIR="/tmp/k8s_repo_setup"
KUSTOMIZE_IMAGE_NAME="your-repo/${SERVICE_NAME}-image"

echo
echo "--- Configuration Summary ---"
echo "Service Name:      ${SERVICE_NAME}"
echo "Node Version:      ${NODE_VERSION}"
echo "Package Manager:   ${PKG_MANAGER}"
echo "K8s Repo Path:     ${K8S_REPO_PATH}"
echo "---------------------------"
echo

# --- 1. Git Operations: Clone the k8s repo ---
echo "Cloning k8s repository into a temporary directory..."
rm -rf "${TEMP_K8S_DIR}"
git clone "https://${GITLAB_DEPLOY_USER}:${GITLAB_DEPLOY_TOKEN}@${K8S_REPO_HOST}/${K8S_REPO_PATH}.git" "${TEMP_K8S_DIR}"

# --- Define K8s paths inside the cloned repo ---
BASE_DIR="${TEMP_K8S_DIR}/base/${SERVICE_NAME}"
DEV_OVERLAY_DIR="${TEMP_K8S_DIR}/overlays/dev"
PROD_OVERLAY_DIR="${TEMP_K8S_DIR}/overlays/prod"

# --- 2. Create CI/CD Files in the local service directory ---
echo "Creating CI/CD files in ${SERVICE_DIR}..."
# ... (Dockerfile and .gitlab-ci.yml generation logic is the same as before)
DOCKERFILE_CONTENT=""
if [ -f "${SERVICE_DIR}/svelte.config.js" ]; then
  DOCKERFILE_CONTENT=$(cat <<EOF
# Stage 1: Builder
FROM oven/bun:1 AS builder
WORKDIR /app
COPY package.json bun.lockb* tsconfig.json svelte.config.js vite.config.ts ./
RUN bun install --frozen-lockfile
COPY . .
RUN bun run build
# Stage 2: Runner
FROM node:${NODE_VERSION}-alpine
WORKDIR /app
ENV NODE_ENV=production
COPY --from=builder /app/.svelte-kit/output .
EXPOSE 3000
CMD ["node", "index.js"]
EOF
)
else
  INSTALL_CMD="npm install"
  if [ "${PKG_MANAGER}" == "yarn" ]; then INSTALL_CMD="yarn install"; fi
  if [ "${PKG_MANAGER}" == "pnpm" ]; then INSTALL_CMD="pnpm install"; fi
  if [ "${PKG_MANAGER}" == "bun" ]; then INSTALL_CMD="bun install"; fi
  DOCKERFILE_CONTENT=$(cat <<EOF
# Stage 1: Builder
FROM node:${NODE_VERSION}-alpine AS builder
WORKDIR /app
COPY package*.json yarn.lock* pnpm-lock.yaml bun.lockb* ./
RUN ${INSTALL_CMD}
COPY . .
RUN ${INSTALL_CMD} run build
RUN npm prune --production
# Stage 2: Runner
FROM node:${NODE_VERSION}-alpine
WORKDIR /app
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/build ./build
COPY --from=builder /app/package.json ./
EXPOSE 3000
CMD [ "npm", "start" ]
EOF
)
fi
echo "${DOCKERFILE_CONTENT}" > "${SERVICE_DIR}/Dockerfile"

cat > "${SERVICE_DIR}/.gitlab-ci.yml" << EOF
variables:
  SERVICE_NAME: "${SERVICE_NAME}"
  KUSTOMIZE_IMAGE_NAME: "${KUSTOMIZE_IMAGE_NAME}"
  K8S_REPO_PATH: "${K8S_REPO_PATH}"
  IMAGE_TAG: \$CI_REGISTRY_IMAGE:\$CI_COMMIT_SHORT_SHA
  KUBECTL_PATH: /opt/bitnami/kubectl/bin/kubectl
stages:
  - build
  - validate
  - deploy_dev
  - deploy_prod
.kubectl_template:
  image:
    name: bitnami/kubectl:latest
    entrypoint: [""]
  tags:
    - docker
  before_script:
    - rm -rf k8s
    - git clone "https://gitlab-ci-token:\${CI_JOB_TOKEN}@\${CI_SERVER_HOST}/\${K8S_REPO_PATH}.git"
    - \${KUBECTL_PATH} config set-cluster meyacrew --server="\$EKS_SERVER" --certificate-authority="\$EKS_CA_CERT"
    - \${KUBECTL_PATH} config set-credentials gitlab --token="\$EKS_GITLAB_TOKEN"
    - \${KUBECTL_PATH} config set-context default --cluster=meyacrew --user=gitlab
    - \${KUBECTL_PATH} config use-context default
build:
  stage: build
  image: docker:20.10.16
  services:
    - docker:20.10.16-dind
  tags:
    - docker
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
    - cd k8s/overlays/dev
    - \${KUBECTL_PATH} kustomize edit set image \$KUSTOMIZE_IMAGE_NAME=\$IMAGE_TAG
    - \${KUBECTL_PATH} apply -k . --dry-run=client
    - cd ../../overlays/prod
    - \${KUBECTL_PATH} kustomize edit set image \$KUSTOMIZE_IMAGE_NAME=\$IMAGE_TAG
    - \${KUBECTL_PATH} apply -k . --dry-run=client
  rules:
    - if: '\$CI_COMMIT_BRANCH == "deploy_development" || \$CI_COMMIT_BRANCH == "deploy_productions" || \$CI_COMMIT_TAG'
deploy_dev:
  stage: deploy_dev
  extends: .kubectl_template
  script:
    - cd k8s/overlays/dev
    - \${KUBECTL_PATH} kustomize edit set image \$KUSTOMIZE_IMAGE_NAME=\$IMAGE_TAG
    - \${KUBECTL_PATH} apply -k .
  rules:
    - if: '\$CI_COMMIT_BRANCH == "deploy_development"'
deploy_prod:
  stage: deploy_prod
  extends: .kubectl_template
  script:
    - cd k8s/overlays/prod
    - \${KUBECTL_PATH} kustomize edit set image \$KUSTOMIZE_IMAGE_NAME=\$IMAGE_TAG
    - \${KUBECTL_PATH} apply -k .
  rules:
    - if: '\$CI_COMMIT_BRANCH == "deploy_productions" || \$CI_COMMIT_TAG'
      when: manual
EOF

# --- 3. Create Kubernetes Manifests in the cloned repo ---
echo "Creating Kubernetes manifests in ${TEMP_K8S_DIR}..."
mkdir -p "${BASE_DIR}" "${DEV_OVERLAY_DIR}" "${PROD_OVERLAY_DIR}"
# ... (rest of K8s file generation is the same)
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

# --- 4. Update Main Kustomization Files in the cloned repo ---
echo "Updating main kustomization files..."
echo "- ./${SERVICE_NAME}" >> "${TEMP_K8S_DIR}/base/kustomization.yaml"
DEV_PATCH_CONTENT="{\"path\": \"${SERVICE_NAME}-deployment-patch.yaml\", \"target\": {\"kind\": \"Deployment\", \"name\": \"${SERVICE_NAME}\"}}"
PROD_PATCH_CONTENT="{\"path\": \"${SERVICE_NAME}-deployment-patch.yaml\", \"target\": {\"kind\": \"Deployment\", \"name\": \"${SERVICE_NAME}\"}}"
yq e -i ".patches += [${DEV_PATCH_CONTENT}]" "${DEV_OVERLAY_DIR}/kustomization.yaml"
yq e -i ".patches += [${PROD_PATCH_CONTENT}]" "${PROD_OVERLAY_DIR}/kustomization.yaml"

# --- 5. Git Operations: Commit and Push changes to the k8s repo ---
echo "Committing and pushing changes to the k8s repository..."
cd "${TEMP_K8S_DIR}"
git config --global user.name "Service Setup Script"
git config --global user.email "script@example.com"
git add .
git commit -m "feat(${SERVICE_NAME}): Add initial Kubernetes manifests and overlays"
git push

# --- 6. Cleanup ---
echo "Cleaning up temporary directory..."
rm -rf "${TEMP_K8S_DIR}"

echo "--- Successfully set up service: ${SERVICE_NAME} ---"
echo "NOTE: This script uses 'yq' to modify YAML files. Please install it if you haven't (brew install yq)."
echo "Review the generated files in '${SERVICE_DIR}' and the commit in your k8s repository."