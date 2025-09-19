apiVersion: apps/v1
kind: Deployment
metadata:
  name: __APP_NAME__
  labels:
    app: __APP_NAME__
    version: __IMAGE_TAG__
spec:
  replicas: __REPLICAS__
  selector:
    matchLabels:
      app: __APP_NAME__
  template:
    metadata:
      labels:
        app: __APP_NAME__
        version: __IMAGE_TAG__
    spec:
      containers:
      - name: __APP_NAME__
        image: __REGISTRY_IMAGE__:__IMAGE_TAG__
        ports:
        - containerPort: __APP_PORT__
          name: http
        env:
        - name: NODE_ENV
          value: __ENVIRONMENT__
        - name: PORT
          value: "__APP_PORT__"
        - name: VITE_PUBLIC_API_BASE_URL
          value: "__API_BASE_URL__"
        resources:
          requests:
            memory: "64Mi"
            cpu: "50m"
          limits:
            memory: "256Mi"
            cpu: "250m"
        livenessProbe:
          httpGet:
            path: /
            port: http
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /
            port: http
          initialDelaySeconds: 5
          periodSeconds: 5
      imagePullSecrets:
      - name: registry-secret