#!/bin/bash
# Déploiement complet du lab (Étape 1)

set -e

echo "=========================================="
echo "   DÉPLOIEMENT COMPLET LAB KUBERNETES"
echo "=========================================="

echo ""
echo "[1/7] Création des namespaces..."
./create-namespaces.sh

echo ""
echo "[2/7] Déploiement Prometheus + Grafana..."
./deploy-prometheus-grafana.sh

echo ""
echo "[3/7] Déploiement RabbitMQ..."
kubectl apply -f ../lab/d-messaging/rabbitmq.yaml
kubectl wait --for=condition=ready pod -l app=rabbitmq -n messaging --timeout=300s

echo ""
echo "[4/7] Déploiement des applications (orders-api + worker)..."
kubectl apply -f ../lab/a-admission/orders-api-worker.yaml
kubectl wait --for=condition=ready pod -l app=orders-api -n app --timeout=180s
kubectl wait --for=condition=ready pod -l app=worker -n app --timeout=180s

echo ""
echo "[5/7] Déploiement Kyverno..."
./deploy-kyverno.sh

echo ""
echo "[6/7] Déploiement KEDA..."
./deploy-keda.sh

echo ""
echo "[7/7] Configuration RabbitMQ (vhost, queues, DLQ)..."
kubectl exec -it rabbitmq-0 -n messaging -- bash -c "
rabbitmqctl add_vhost /orders
rabbitmqctl set_permissions -p /orders admin '.*' '.*' '.*'
rabbitmqadmin -u admin -p admin -V /orders declare exchange name=orders type=direct durable=true
rabbitmqadmin -u admin -p admin -V /orders declare queue name=orders.q durable=true arguments='{\"x-message-ttl\":300000,\"x-dead-letter-exchange\":\"orders.dlx\"}'
rabbitmqadmin -u admin -p admin -V /orders declare exchange name=orders.dlx type=fanout durable=true
rabbitmqadmin -u admin -p admin -V /orders declare queue name=orders.dlq durable=true
rabbitmqadmin -u admin -p admin -V /orders declare binding source=orders destination=orders.q routing_key=order
rabbitmqadmin -u admin -p admin -V /orders declare binding source=orders.dlx destination=orders.dlq
"

echo ""
echo "=========================================="
echo "   ✅ DÉPLOIEMENT TERMINÉ !"
echo "=========================================="
echo ""
echo "Vérification finale:"
kubectl get nodes
kubectl get pods -A
