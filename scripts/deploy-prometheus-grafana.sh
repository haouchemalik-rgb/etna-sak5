#!/bin/bash
# Déploiement de la stack observabilité (Prometheus + Grafana)

echo "=== Déploiement kube-prometheus-stack ==="
helm install prometheus prometheus-community/kube-prometheus-stack \
  --namespace ops \
  --set prometheus.prometheusSpec.retention=6h \
  --set prometheus.prometheusSpec.resources.requests.memory=512Mi \
  --set prometheus.prometheusSpec.resources.limits.memory=1Gi

echo "=== Attente du démarrage des pods ==="
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=grafana -n ops --timeout=300s

echo "=== Récupération du mot de passe Grafana ==="
kubectl get secret -n ops prometheus-grafana -o jsonpath="{.data.admin-password}" | base64 -d
echo ""

echo "=== Prometheus + Grafana déployés ! ==="
kubectl get pods -n ops
