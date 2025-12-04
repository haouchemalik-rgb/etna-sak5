#!/bin/bash
# Création des namespaces du projet

echo "=== Création des namespaces ==="
kubectl create namespace app
kubectl create namespace messaging
kubectl create namespace ops

echo "=== Namespaces créés ==="
kubectl get namespaces
