#!/bin/bash
# Déploiement de Kyverno (politiques de sécurité)

echo "=== Déploiement Kyverno ==="
helm install kyverno kyverno/kyverno --namespace kyverno --create-namespace

echo "=== Attente du démarrage ==="
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=kyverno -n kyverno --timeout=300s

echo "=== Kyverno déployé ! ==="
kubectl get pods -n kyverno
