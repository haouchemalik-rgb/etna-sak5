#!/bin/bash
# Déploiement de KEDA (autoscaling)

echo "=== Déploiement KEDA ==="
helm install keda kedacore/keda --namespace keda --create-namespace

echo "=== Attente du démarrage ==="
kubectl wait --for=condition=ready pod -l app=keda-operator -n keda --timeout=300s

echo "=== KEDA déployé ! ==="
kubectl get pods -n keda
