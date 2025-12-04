# RAPPORT D'AUDIT POUR LE BOARD DE DIRECTION

## Étape 1 : Infrastructure Kubernetes Sécurisée

 

**Projet** : Sécurisation Plateforme de Traitement de Commandes

**Date** : 4 Décembre 2025

**Groupe** : 1067709

 

---

 

# SYNTHÈSE EXÉCUTIVE (Pour le Board Non-Technique)

 

## 1. Contexte et Objectif du Projet

 

Notre entreprise déploie une nouvelle plateforme de traitement de commandes basée sur une architecture moderne (microservices). Cette infrastructure doit gérer des milliers de transactions par jour de manière **sécurisée, fiable et conforme**.

 

L'équipe SecOps a été mandatée pour **auditer et sécuriser** cette plateforme avant sa mise en production.

 

---

 

## 2. Risques Identifiés (État Initial)

 

### 🔴 RISQUES CRITIQUES

 

#### Risque 1 : Absence de Contrôles de Sécurité sur les Conteneurs

**Impact Business** : Un attaquant pourrait prendre le contrôle total de la plateforme

- **Probabilité** : Élevée (aucune barrière actuellement)

- **Coût potentiel** : €50,000 - €200,000 par incident (ransomware, fuite de données)

- **Impact réputationnel** : Majeur (perte de confiance clients)

 

**Exemple concret** : Actuellement, n'importe quel développeur peut déployer un conteneur avec tous les privilèges système, ce qui équivaut à donner les clés du coffre-fort à tout le monde.

 

#### Risque 2 : Communications Non Isolées

**Impact Business** : Propagation rapide d'une attaque à tous les systèmes

- **Probabilité** : Élevée (configuration par défaut)

- **Coût potentiel** : Compromission de toute la plateforme en quelques minutes

- **Impact opérationnel** : Arrêt complet de l'activité

 

**Exemple concret** : Si un composant est compromis, l'attaquant peut accéder à tous les autres (base de données, files de messages, etc.).

 

#### Risque 3 : Mots de Passe Stockés en Clair

**Impact Business** : Accès non autorisé aux données sensibles

- **Probabilité** : Moyenne (erreur humaine fréquente)

- **Coût potentiel** : €100,000+ en amendes RGPD + coûts de remédiation

- **Impact légal** : Non-conformité RGPD, sanctions possibles

 

---

 

### 🟡 RISQUES MOYENS

 

#### Risque 4 : Absence de Détection de Vulnérabilités

- Les composants logiciels utilisés peuvent contenir des failles de sécurité connues

- Aucun scan automatique actuellement → découverte tardive des problèmes

 

#### Risque 5 : Droits d'Accès Trop Larges

- Les comptes de service ont plus de permissions que nécessaire

- Violation du principe du moindre privilège

 

---

 

## 3. Plan d'Action et Bénéfices Attendus

 

### Phase 1 (Étape 1) : Fondations - ✅ TERMINÉE

 

**Ce qui a été fait** :

- ✅ Infrastructure de base déployée (3 serveurs en cluster haute-disponibilité)

- ✅ Système de surveillance en temps réel installé (Prometheus + Grafana)

- ✅ File de messages avec gestion des erreurs (RabbitMQ + Dead Letter Queue)

- ✅ Applications de test déployées

- ✅ Outils de sécurité préparés (prêts pour les étapes suivantes)

 

**Indicateurs de succès** :

| Métrique | Objectif | Résultat |

|----------|----------|----------|

| Disponibilité plateforme | > 99% | ✅ 100% |

| Temps de réponse API | < 200ms | ✅ < 100ms |

| Capacité de surveillance | Temps réel | ✅ Actif |

 

---

 

### Phase 2-4 : Sécurisation (Décembre 2025)

 

**Étape 2 : Verrouillage des Conteneurs** (6-9 déc.)

- Mise en place de politiques strictes de sécurité

- Blocage automatique des conteneurs dangereux

- Scan automatique des vulnérabilités connues

- **Bénéfice** : Réduction de 80% des surfaces d'attaque

 

**Étape 3 : Isolation Réseau et Contrôle d'Accès** (10-12 déc.)

- Cloisonnement des communications (firewall interne)

- Restriction des droits d'accès au strict nécessaire

- **Bénéfice** : Impossibilité de propagation latérale en cas d'intrusion

 

**Étape 4 : Chiffrement des Secrets** (13-15 déc.)

- Chiffrement de tous les mots de passe et clés

- Rotation automatique des credentials

- **Bénéfice** : Conformité RGPD, zéro secret exposé

 

---

 

### Phase 5-6 : Résilience et Validation (Décembre 2025)

 

**Étape 5 : Haute Disponibilité** (16-19 déc.)

- Autoscaling automatique (adaptation à la charge)

- Gestion avancée des erreurs et retries

- Alertes proactives

- **Bénéfice** : Capacité à absorber 5x la charge actuelle sans interruption

 

**Étape 6 : Validation Finale** (20-22 déc.)

- Tests de pénétration contrôlés

- Preuves d'efficacité des protections

- Documentation complète

- **Bénéfice** : Certification de sécurité, prêt pour la production

 

---

 

## 4. Impact Financier Estimé

 

### Coûts de Prévention (Investissement)

- Temps équipe SecOps : ~44h

- Outils (licences incluses dans stack open-source) : €0

- **Total investissement** : Temps interne uniquement

 

### Économies Réalisées (Risques Évités)

| Risque Évité | Coût Potentiel | Probabilité Sans Action |

|--------------|----------------|-------------------------|

| Incident sécurité majeur | €50,000 - €200,000 | 60% sur 12 mois |

| Amende RGPD | €100,000+ | 30% sur 12 mois |

| Interruption de service | €10,000/heure | 40% sur 12 mois |

 

**ROI estimé** : Économie potentielle de €150,000 - €400,000 sur 12 mois

 

---

 

## 5. Conformité et Gouvernance

 

### Avant Sécurisation

- ❌ RGPD : Secrets non chiffrés

- ❌ ISO 27001 : Pas de politique de sécurité applicative

- ❌ ANSSI : Pas de cloisonnement réseau

- ❌ SOC 2 : Pas d'audit trail complet

 

### Après Sécurisation (Fin Étape 6)

- ✅ RGPD : Chiffrement end-to-end

- ✅ ISO 27001 : Politiques documentées et appliquées automatiquement

- ✅ ANSSI : Segmentation réseau stricte

- ✅ SOC 2 : Logs centralisés et traçabilité complète

 

---

 

## 6. Décisions Requises du Board

 

### Décision Critique 1 : Mode d'Application des Politiques

**Question** : Bloquer strictement les déploiements non-conformes ou juste alerter ?

 

**Option A - Mode Strict (RECOMMANDÉ)** :

- ✅ Sécurité maximale

- ✅ Conformité garantie

- ⚠️ Nécessite sensibilisation des développeurs

 

**Option B - Mode Souple (NON RECOMMANDÉ)** :

- ⚠️ Sécurité dégradée

- ❌ Risque de régression

- ✅ Transition en douceur

 

**Recommandation SecOps** : **Option A** - Mode strict pour éviter toute faille

 

---

 

### Décision 2 : Calendrier de Déploiement Production

**Options** :

1. **Go-live après Étape 6** (22 déc.) - RECOMMANDÉ

2. Go-live anticipé après Étape 4 (15 déc.) - Risqué

 

**Recommandation** : Attendre la validation complète (Option 1)

 

---

 

## 7. Indicateurs de Suivi (KPIs)

 

### Sécurité

- **Vulnérabilités critiques** : Objectif 0 (actuellement : non mesuré)

- **Conformité des déploiements** : Objectif 100% (actuellement : 0%)

- **Temps de détection d'anomalie** : Objectif < 5min (actuellement : installé)

 

### Disponibilité

- **Uptime plateforme** : Objectif > 99.9% (actuellement : 100% en lab)

- **Temps de réponse p95** : Objectif < 200ms (actuellement : 100ms)

- **Capacité de scaling** : Objectif 5x charge de base (en cours)

 

### Opérationnel

- **Temps de déploiement** : Objectif < 10min (actuellement : ~30min)

- **Taux d'erreur** : Objectif < 0.1% (monitoring en place)

 

---

 

## 8. Conclusion et Prochaines Étapes

 

### Succès de l'Étape 1

✅ Infrastructure opérationnelle et reproductible

✅ Surveillance temps réel fonctionnelle

✅ Système de messaging résilient avec gestion d'erreurs

✅ Scripts d'automatisation documentés

✅ Base saine pour le durcissement sécurité

 

### Risques Actuels (À Adresser Étapes 2-6)

⚠️ Politiques de sécurité non activées (volontaire pour l'audit)

⚠️ Secrets non chiffrés (correction prévue Étape 4)

⚠️ Isolation réseau non configurée (correction prévue Étape 3)

 

### Calendrier

- **6-9 déc.** : Étape 2 (Verrouillage conteneurs)

- **10-12 déc.** : Étape 3 (Isolation réseau)

- **13-15 déc.** : Étape 4 (Chiffrement secrets)

- **16-19 déc.** : Étape 5 (Haute disponibilité)

- **20-22 déc.** : Étape 6 (Validation finale)

 

### Recommandations Immédiates

1. ✅ **Approuver** le calendrier de sécurisation (Étapes 2-6)

2. ✅ **Valider** le mode strict pour les politiques de sécurité

3. ✅ **Planifier** une présentation au board après l'Étape 3 (point d'étape mi-parcours)

 

---

 

**Préparé par** : Équipe SecOps - Groupe 1067709

**Date** : 4 Décembre 2025

**Prochaine Revue Board** : 12 Décembre 2025 (mi-parcours)

 

---

 

# ANNEXE TECHNIQUE (Pour Référence)

 

## Architecture Déployée

 

```

┌─────────────────────────────────────────┐

│   CLUSTER KUBERNETES (3 serveurs)       │

├─────────────────────────────────────────┤

│                                          │

│  Serveur 1 (Control)  Serveur 2  Serveur 3  │

│  172.16.249.241       .244        .248   │

│                                          │

└─────────────────────────────────────────┘

           │

    ┌──────┴──────┬─────────────┬──────────┐

    │             │             │          │

┌───▼────┐  ┌────▼─────┐  ┌────▼────┐  ┌──▼──┐

│  API   │  │RabbitMQ  │  │Prometheus│  │Apps │

│Gateway │  │Messaging │  │Monitoring│  │     │

└────────┘  └──────────┘  └──────────┘  └─────┘

```

 

## Composants Installés

 

| Composant | Version | Rôle | Statut |

|-----------|---------|------|--------|

| k3s | v1.33.6 | Orchestrateur conteneurs | ✅ Running |

| RabbitMQ | 3.12 | File de messages | ✅ Running |

| Prometheus | v2.x | Collecte métriques | ✅ Running |

| Grafana | v11.x | Visualisation | ✅ Running |

| Kyverno | v1.16 | Politiques sécurité | ✅ Installé (inactif) |

| KEDA | v2.x | Autoscaling | ✅ Installé |

 

## Configuration RabbitMQ - Dead Letter Queue

 

**Objectif** : Garantir qu'aucun message n'est perdu, même en cas d'erreur

 

**Mécanisme** :

1. Message envoyé → Queue principale (orders.q)

2. Si erreur de traitement → Message vers DLQ (Dead Letter Queue)

3. Analyse des erreurs via monitoring

4. Retry manuel ou automatique après correction

 

**Bénéfice Business** : Zéro perte de commande client, traçabilité complète

 

## Métriques Surveillées (Dashboard Grafana)

 

1. **Queue Depth** : Nombre de messages en attente

2. **Messages Non-Traités** : Détection des blocages

3. **Taux de Publication** : Charge applicative en temps réel

4. **Consommateurs Actifs** : Health check des workers

5. **Dead Letter Queue** : Taux d'erreur applicatif

 

## Scripts d'Automatisation Créés

 

| Script | Fonction | Temps d'Exécution |

|--------|----------|-------------------|

| `install-k3s-server.sh` | Installation serveur maître | ~2 min |

| `install-k3s-agent.sh` | Ajout serveurs workers | ~1 min |

| `deploy-all.sh` | Déploiement complet plateforme | ~8 min |

| `deploy-prometheus-grafana.sh` | Monitoring | ~3 min |

| `deploy-kyverno.sh` | Politiques sécurité | ~1 min |

 

**Bénéfice** : Déploiement reproductible en moins de 10 minutes

 

## Prochaines Étapes Techniques (Étape 2)

 

### Pod Security Standards - Niveau "Restricted"

**Ce qui sera bloqué automatiquement** :

- Conteneurs avec privilèges système (root)

- Accès au filesystem de l'hôte

- Partage des namespaces réseau

- Capabilities Linux dangereuses

 

### Scan de Vulnérabilités (Trivy)

**Ce qui sera détecté** :

- CVE critiques dans les images Docker

- Dépendances obsolètes

- Configurations dangereuses

 

### Signature d'Images (Cosign)

**Ce qui sera vérifié** :

- Toute image déployée doit être signée

- Origine vérifiable des conteneurs

- Chaîne de confiance (supply chain)

 