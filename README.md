# ISR-SAK5 - Sécurité & Audit Kubernetes - Groupe 1067709

Projet d'audit et de durcissement d'un cluster Kubernetes avec infrastructure messaging (RabbitMQ).

## 📋 Table des Matières

- [Infrastructure](#infrastructure)
- [Installation](#installation)
- [Déploiement](#déploiement)
- [Accès aux Services](#accès-aux-services)
- [Structure du Projet](#structure-du-projet)
- [Étapes du Projet](#étapes-du-projet)

---

## 🏗️ Infrastructure

### Cluster Kubernetes (k3s)
- **3 VMs Debian 12** (2 vCPU / 6 Go RAM / 40 Go disque)
- **VM1** (172.16.249.241) : Control-plane
- **VM2** (172.16.249.244) : Worker
- **VM3** (172.16.249.248) : Worker

### Namespaces
- `app` : Applications métier (orders-api, worker)
- `messaging` : Infrastructure RabbitMQ
- `ops` : Observabilité (Prometheus, Grafana)
- `kyverno` : Politiques de sécurité
- `keda` : Autoscaling

---

## 🚀 Installation

### Prérequis
- Debian 12 sur les 3 VMs
- Accès SSH aux VMs
- Connexion Internet (pour télécharger les images)

### 1. Installation du Cluster k3s

**Sur VM1 (Server)** :
```bash
cd scripts
./install-k3s-server.sh
```

Copier le token affiché à la fin.

**Sur VM2 et VM3 (Agents)** :
```bash
./install-k3s-agent.sh 172.16.249.241 <TOKEN>
```

Vérifier que les 3 nœuds sont Ready :
```bash
kubectl get nodes
```

### 2. Installation de Helm
```bash
./install-helm.sh
```

---

## 📦 Déploiement

### Option 1 : Déploiement Complet (Recommandé)

```bash
cd scripts
./deploy-all.sh
```

Cette commande déploie dans l'ordre :
1. Namespaces
2. Prometheus + Grafana
3. RabbitMQ
4. Applications (orders-api + worker)
5. Kyverno
6. KEDA
7. Configuration RabbitMQ (vhost, queues, DLQ)

### Option 2 : Déploiement Manuel

```bash
# 1. Créer les namespaces
./create-namespaces.sh

# 2. Déployer Prometheus + Grafana
./deploy-prometheus-grafana.sh

# 3. Déployer RabbitMQ
kubectl apply -f ../lab/d-messaging/rabbitmq.yaml

# 4. Déployer les applications
kubectl apply -f ../lab/a-admission/orders-api-worker.yaml

# 5. Déployer Kyverno
./deploy-kyverno.sh

# 6. Déployer KEDA
./deploy-keda.sh

# 7. Configurer RabbitMQ
kubectl exec -it rabbitmq-0 -n messaging -- bash
# Puis exécuter les commandes rabbitmqctl/rabbitmqadmin
```

---

## 🌐 Accès aux Services

### RabbitMQ Management UI

**Port-forward** :
```bash
kubectl port-forward -n messaging svc/rabbitmq 15672:15672 --address 0.0.0.0
```

**Accès** : http://172.16.249.241:15672
- Username: `admin`
- Password: `admin`

### Grafana

**Port-forward** :
```bash
kubectl port-forward -n ops svc/prometheus-grafana 3000:80 --address 0.0.0.0
```

**Récupérer le mot de passe** :
```bash
kubectl get secret -n ops prometheus-grafana -o jsonpath="{.data.admin-password}" | base64 -d
echo
```

**Accès** : http://172.16.249.241:3000
- Username: `admin`
- Password: (voir commande ci-dessus)

### Prometheus

**Port-forward** :
```bash
kubectl port-forward -n ops svc/prometheus-kube-prometheus-prometheus 9090:9090 --address 0.0.0.0
```

**Accès** : http://172.16.249.241:9090

---

## 📁 Structure du Projet

```
kube-bug-hunt-group-1067709/
├── lab/
│   ├── a-admission/              # Manifests applications + futurs tests PSS
│   │   └── orders-api-worker.yaml
│   ├── b-rbac-net/              # NetworkPolicy + RBAC (Étape 3)
│   ├── c-secrets-ci/            # Sealed Secrets (Étape 4)
│   └── d-messaging/             # RabbitMQ + KEDA (Étape 5)
│       └── rabbitmq.yaml
│
├── policies/
│   ├── admission/               # Politiques Kyverno (Étape 2)
│   ├── network/                 # NetworkPolicies (Étape 3)
│   └── rbac/                    # Roles, RoleBindings (Étape 3)
│
├── tests/
│   ├── kuttl/                   # Tests end-to-end
│   ├── kyverno/                 # Tests de politiques
│   └── conftest/                # Tests OPA
│
├── scripts/
│   ├── install-k3s-server.sh    # Installation k3s server
│   ├── install-k3s-agent.sh     # Installation k3s agent
│   ├── install-helm.sh          # Installation Helm + repos
│   ├── create-namespaces.sh     # Création des namespaces
│   ├── deploy-prometheus-grafana.sh
│   ├── deploy-kyverno.sh
│   ├── deploy-keda.sh
│   └── deploy-all.sh            # Déploiement complet
│
├── dashboards/                  # Dashboards Grafana JSON
│
├── validation/
│   ├── Etape-1/                 # Rapports + captures Étape 1
│   ├── Etape-2/
│   ├── ...
│   └── Etape-6/
│
├── .gitlab-ci.yml               # Pipeline CI/CD
├── .gitignore
└── README.md
```

---

## 📊 Étapes du Projet

### ✅ Étape 1 : Mise en place du lab reproductible (TERMINÉE)
- [x] Cluster k3s (3 nœuds)
- [x] Prometheus + Grafana
- [x] RabbitMQ avec DLQ
- [x] orders-api + worker
- [x] Kyverno
- [x] KEDA
- [x] Dashboard Grafana "RabbitMQ Golden Signals"
- [x] Scripts d'installation et de déploiement

### 🔜 Étape 2 : Admission & Supply Chain
- [ ] Pod Security Standards (PSS) niveau restricted
- [ ] Politiques Kyverno (deny privileged, hostPath, :latest)
- [ ] Scan Trivy images + manifests
- [ ] Signature d'images avec Cosign
- [ ] Tests KUTTL + kyverno-test

### 🔜 Étape 3 : Réseau & RBAC
- [ ] NetworkPolicy default-deny
- [ ] RBAC moindre privilège
- [ ] Isolation réseau AMQP
- [ ] kubectl-who-can audit

### 🔜 Étape 4 : Secrets & CI durcie
- [ ] Sealed Secrets / SOPS
- [ ] CI protégée (approbations, pin actions)
- [ ] Tests Conftest/OPA
- [ ] Zéro secret en clair

### 🔜 Étape 5 : Messaging robuste & autoscaling
- [ ] DLQ + retries
- [ ] Idempotence worker
- [ ] KEDA autoscaling
- [ ] SLO + alertes

### 🔜 Étape 6 : Preuves & rapport final
- [ ] PoC exploitations
- [ ] Rapport d'audit final
- [ ] Démonstration

---

## 🔧 Commandes Utiles

### Vérifier l'état du cluster
```bash
kubectl get nodes
kubectl get pods -A
kubectl get svc -A
```

### Logs des applications
```bash
kubectl logs -n app deployment/orders-api -f
kubectl logs -n app deployment/worker -f
```

### Restart un deployment
```bash
kubectl rollout restart deployment/orders-api -n app
```

### Accéder à RabbitMQ en shell
```bash
kubectl exec -it rabbitmq-0 -n messaging -- bash
```

---

## 📚 Documentation

- [Kubernetes Pod Security Standards](https://kubernetes.io/docs/concepts/security/pod-security-standards/)
- [Kyverno](https://kyverno.io/)
- [RabbitMQ](https://www.rabbitmq.com/)
- [KEDA](https://keda.sh/)
- [Prometheus](https://prometheus.io/)
- [Grafana](https://grafana.com/)

---

## 👥 Équipe

**Groupe** : 1067709
**Projet** : ISR-SAK5
**Année** : 2025
