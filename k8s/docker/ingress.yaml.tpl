apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: __APP_NAME__-ingress
  annotations:
    konghq.com/strip-path: "true"
    konghq.com/plugins: "__APP_NAME__-cors,__APP_NAME__-rate-limit"
    cert-manager.io/cluster-issuer: "letsencrypt-prod"
spec:
  ingressClassName: kong
  tls:
  - hosts:
    - __HOST_DOMAIN__
    secretName: __APP_NAME__-tls
  rules:
  - host: __HOST_DOMAIN__
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: __APP_NAME__-service
            port:
              number: __APP_PORT__