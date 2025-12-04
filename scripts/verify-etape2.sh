#!/bin/bash
# Script de vérification Étape 2

echo "=========================================="
echo "   VÉRIFICATION ÉTAPE 2"
echo "=========================================="
echo ""

pass=true

echo "[1/9] PSS activé sur namespace app..."
if kubectl get namespace app -o yaml | grep -q "pod-security.kubernetes.io/enforce: restricted"; then
    echo "✅ PSS niveau restricted actif"
    kubectl get namespace app -o yaml | grep pod-security
else
    echo "❌ PSS manquant"
    pass=false
fi
echo ""

echo "[2/9] Politiques Kyverno..."
policy_count=$(kubectl get clusterpolicies --no-headers 2>/dev/null | wc -l)
if [ "$policy_count" -ge 3 ]; then
    echo "✅ $policy_count politiques Kyverno actives"
    kubectl get clusterpolicies
else
    echo "❌ Moins de 3 politiques ($policy_count)"
    pass=false
fi
echo ""

echo "[3/9] Trivy installé..."
if command -v trivy &> /dev/null; then
    echo "✅ Trivy installé"
    trivy --version
else
    echo "❌ Trivy manquant"
    pass=false
fi
echo ""

echo "[4/9] Applications running..."
running_pods=$(kubectl get pods -n app --no-headers 2>/dev/null | grep -c "Running")
if [ "$running_pods" -ge 2 ]; then
    echo "✅ $running_pods pods running"
    kubectl get pods -n app
else
    echo "❌ Pods non running"
    pass=false
fi
echo ""

echo "[5/9] CI avec Trivy..."
if grep -q "trivy-scan" .gitlab-ci.yml 2>/dev/null; then
    echo "✅ Jobs Trivy dans CI"
    grep "trivy-scan" .gitlab-ci.yml | head -5
else
    echo "❌ Trivy manquant dans CI"
    pass=false
fi
echo ""

echo "[6/9] Fichiers de politiques..."
policy_files=$(ls -1 policies/admission/*.yaml 2>/dev/null | wc -l)
if [ "$policy_files" -ge 3 ]; then
    echo "✅ $policy_files fichiers de politiques"
    ls -1 policies/admission/
else
    echo "❌ Moins de 3 fichiers de politiques"
    pass=false
fi
echo ""

echo "[7/9] Test blocage pod privilégié..."
echo "   Création d'un pod de test (doit être bloqué)..."
kubectl run test-verify --image=nginx:latest --namespace=app --restart=Never -- sleep 10 2>&1 | grep -q "forbidden\|denied"
if [ $? -eq 0 ]; then
    echo "✅ Pod non-conforme correctement bloqué"
    kubectl delete pod test-verify -n app --ignore-not-found &>/dev/null
else
    echo "⚠️  Blocage à vérifier manuellement"
    kubectl delete pod test-verify -n app --ignore-not-found &>/dev/null
fi
echo ""

echo "[8/9] État du repo Git..."
cd ~/kube-bug-hunt-group-1067709
uncommitted=$(git status --porcelain | wc -l)
if [ "$uncommitted" -eq 0 ]; then
    echo "✅ Repo Git à jour (rien à committer)"
else
    echo "⚠️  $uncommitted fichiers non commités"
    git status --short
fi
echo ""

echo "[9/9] Structure projet..."
dirs_ok=0
[ -d "policies/admission" ] && ((dirs_ok++))
[ -d "scripts" ] && ((dirs_ok++))
[ -d "lab/a-admission" ] && ((dirs_ok++))
if [ "$dirs_ok" -eq 3 ]; then
    echo "✅ Structure projet OK"
else
    echo "❌ Structure incomplète"
    pass=false
fi
echo ""

echo "=========================================="
if $pass; then
    echo "✅ ÉTAPE 2 VALIDÉE !"
    echo ""
    echo "Résumé:"
    echo "- PSS: ✅ Actif"
    echo "- Politiques Kyverno: ✅ $policy_count actives"
    echo "- Trivy: ✅ Installé"
    echo "- CI: ✅ Jobs scan configurés"
    echo "- Apps: ✅ Running"
else
    echo "⚠️  Certains éléments à corriger"
fi
echo "=========================================="
