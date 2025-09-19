apiVersion: v1
kind: Service
metadata:
  name: __APP_NAME__-service
  labels:
    app: __APP_NAME__
spec:
  selector:
    app: __APP_NAME__
  ports:
  - name: http
    port: __APP_PORT__
    targetPort: __APP_PORT__
    protocol: TCP
  type: ClusterIP