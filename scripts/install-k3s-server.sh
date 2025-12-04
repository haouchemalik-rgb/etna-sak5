#!/bin/bash
# Script d'installation k3s en mode serveur (VM1)

echo "=== Installation k3s Server ==="
curl -sfL https://get.k3s.io | sh -s - server \
  --disable traefik \
  --write-kubeconfig-mode 644

echo "=== Configuration kubectl pour user non-root ==="
mkdir -p ~/.kube
sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
sudo chown $(id -u):$(id -g) ~/.kube/config
chmod 600 ~/.kube/config
echo 'export KUBECONFIG=~/.kube/config' >> ~/.bashrc

echo "=== Token pour agents ==="
sudo cat /var/lib/rancher/k3s/server/node-token

echo "=== k3s server installé ! ==="
kubectl get nodes
