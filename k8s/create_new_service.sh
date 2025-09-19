#!/bin/bash

# --- Script to generate Kubernetes manifests for a new service ---

# Check if a service name is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <service-name>"
  echo "Example: $0 front-mymovies"
  exit 1
fi

SERVICE_NAME=$1
KUSTOMIZE_IMAGE_NAME="your-repo/${SERVICE_NAME}-image"
BASE_DIR="./base/${SERVICE_NAME}"
DEV_OVERLAY_DIR="./overlays/dev"
PROD_OVERLAY_DIR="./overlays/prod"

echo "--- Creating manifests for service: ${SERVICE_NAME} ---"

# --- 1. Create Base Manifests ---
echo "Creating base manifests in ${BASE_DIR}..."
mkdir -p "${BASE_DIR}"

# Create k8s/base/<service-name>/deployment.yaml
cat > "${BASE_DIR}/deployment.yaml" << EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ${SERVICE_NAME}
  namespace: app
  labels:
    app.kubernetes.io/name: ${SERVICE_NAME}
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
          imagePullPolicy: IfNotPresent
          ports:
            - name: http
              containerPort: 3000
EOF

# Create k8s/base/<service-name>/service.yaml
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

# Create k8s/base/<service-name>/ingress.yaml
cat > "${BASE_DIR}/ingress.yaml" << EOF
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ${SERVICE_NAME}
  namespace: app
  annotations:
    kubernetes.io/ingress.class: kong
spec:
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

# Create k8s/base/<service-name>/kustomization.yaml
cat > "${BASE_DIR}/kustomization.yaml" << EOF
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
namespace: app
resources:
  - deployment.yaml
  - service.yaml
  - ingress.yaml
EOF

# --- 2. Create Overlay Patches ---
echo "Creating overlay patches..."

# Create dev patch
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

# Create prod patch
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

# --- 3. Update Kustomization Files ---
echo "Updating main kustomization files..."

# Update base kustomization
sed -i '' -e "/^- .\/movies-api/a\
- .\/${SERVICE_NAME}" ./base/kustomization.yaml

# Update dev kustomization
sed -i '' -e "/patches:/a\
  - path: ${SERVICE_NAME}-deployment-patch.yaml\n    target:\n      kind: Deployment\n      name: ${SERVICE_NAME}" ${DEV_OVERLAY_DIR}/kustomization.yaml

# Update prod kustomization
sed -i '' -e "/patches:/a\
  - path: ${SERVICE_NAME}-deployment-patch.yaml\n    target:\n      kind: Deployment\n      name: ${SERVICE_NAME}" ${PROD_OVERLAY_DIR}/kustomization.yaml

echo "--- Successfully created all files for service: ${SERVICE_NAME} ---"
echo "Review the generated files and commit them to your repository."
