#!/bin/bash
# Script d'installation k3s en mode agent (VM2, VM3)
# Usage: ./install-k3s-agent.sh <SERVER_IP> <TOKEN>

if [ $# -ne 2 ]; then
    echo "Usage: $0 <SERVER_IP> <TOKEN>"
    echo "Exemple: $0 172.16.249.241 K10abc..."
    exit 1
fi

SERVER_IP=$1
TOKEN=$2

echo "=== Installation k3s Agent ==="
curl -sfL https://get.k3s.io | K3S_URL=https://${SERVER_IP}:6443 \
  K3S_TOKEN=${TOKEN} sh -

echo "=== k3s agent installé ! ==="
