#!/bin/bash
# Installation de Helm et ajout des repositories

echo "=== Installation Helm ==="
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

echo "=== Ajout des repositories Helm ==="
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add kyverno https://kyverno.github.io/kyverno/
helm repo add kedacore https://kedacore.github.io/charts
helm repo update

echo "=== Helm installé et configuré ! ==="
helm version
