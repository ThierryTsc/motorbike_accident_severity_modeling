# 🏍️ Motorbike Accident Severity Modeling

Ce projet vise à modéliser la **gravité des accidents de moto** à partir d’un ensemble de données collectées au Bangladesh.  
L’objectif est d’**identifier les facteurs de risque associés à une gravité plus élevée** des accidents et d’en tirer des recommandations en matière de prévention routière.

---

## 📊 Données utilisées

Le dataset comprend **15 100 observations** avec les variables suivantes :
- `accident_severity` (variable cible ordinale) :  
  - No Accident  
  - Moderate Accident  
  - Severe Accident
- Variables explicatives :
  - `wearing_helmet`
  - `talk_while_riding`
  - `smoke_while_riding`
  - `biker_alcohol`
  - `riding_experience`
  - `bike_speed`

---

## 🧪 Méthodologie

### 1. Analyse exploratoire :
- Statistiques descriptives et visualisations
- Analyse bivariée entre chaque variable explicative et la gravité

### 2. Modélisation :
- Modèle de **régression logistique ordinale** (`polr` du package **MASS**)
- Sélection des variables explicatives selon pertinence statistique et métier

### 3. Validation :
- Prédictions sur l’échantillon d’apprentissage
- **Taux de bonne classification (Accuracy)** : **56.7%**
- **Validation croisée (5-fold)** avec `caret` :
  - Meilleure performance avec la fonction de lien `cauchit`
  - Accuracy moyenne CV : **58.3%**

---

## 📌 Résultats principaux
On se base ici sur les coefficients de ton modèle polr() + leurs signes, tailles, et significativité (via les p-values).
Les coefficients positifs → augmentation de la probabilité d’un accident plus grave.
Les négatifs → réduction du risque.
Voici les **coefficients estimés** par le modèle ordinale, accompagnés de leur **interprétation**, **intervalle de confiance à 95%**, et **valeur p** (approximative) :

| Variable                           | Niveau            | Coefficient | IC95% (Low - High)  | p-value   | Interprétation                                                                 |
|------------------------------------|-------------------|-------------|---------------------|-----------|---------------------------------------------------------------------------------|
| `biker_alcohol`                    | 1 (alcool)        | **+3.21**   | [3.01 ; 3.42]       | < 2e-16   | Risque **massivement accru** d'accident grave                                  |
| `smoke_while_riding`              | parfois           | +0.83       | [0.65 ; 1.01]       | < 2e-16   | Effet significatif d’augmentation du risque                                    |
| `smoke_while_riding`              | régulièrement     | **+16.12**  | [12.8 ; 19.5]       | < 2e-16   | Effet **très extrême** (à interpréter avec prudence – faible effectif probable) |
| `talk_while_riding`               | parfois           | **−0.61**   | [−0.78 ; −0.45]     | < 2e-16   | Effet protecteur surprenant, potentiellement lié à un biais                    |
| `talk_while_riding`               | régulièrement     | +0.95       | [0.75 ; 1.15]       | < 2e-16   | Augmentation claire du risque                                                  |
| `wearing_helmet`                  | Yes               | +0.14       | [0.06 ; 0.22]       | 0.0005    | Effet faible et contre-intuitif (peut refléter une confusion)                 |
| `riding_experience`               | Numérique (années)| −0.0167     | [−0.019 ; −0.014]   | < 2e-16   | Chaque année d’expérience réduit légèrement le risque                          |
| `bike_speed`                      | Numérique (km/h)  | +0.0262     | [0.025 ; 0.028]     | < 2e-16   | La vitesse augmente le risque de gravité                                       |

> ⚠️ Certains effets extrêmes (comme `smoke_while_riding = regularly`) sont probablement dus à un déséquilibre dans les données.
> Le casque semble ne pas avoir un effet protecteur significatif ici, ce qui est probablement dû à un biais dans les données ou une confusion (ex : peut-être que ceux qui portent le casque roulent aussi plus vite ?)

---

## 🛡️ Recommandations en prévention routière

1. **Zéro tolérance sur l'alcool au guidon**  
   L’alcool est de loin le **facteur de risque le plus critique**.

2. **Lutter contre les distractions**  
   Parler en roulant augmente le risque significativement. Nécessité de campagnes de sensibilisation.

3. **Cibler les conducteurs novices**  
   Moins d’expérience = plus de risque. Programmes de formation ou accompagnement renforcé recommandés.

4. **Contrôle de la vitesse**  
   Effet linéaire et significatif → importance des radars et des limitations strictes.

---

## 🗂️ Organisation du dépôt
accident_severity_modeling/
├── data/
│   └── motorbike_accidents_severity_analysis.csv   # Fichier de base
|   └── package_necessaire.txt                      # Listings des packages utilisés durant le projet
├── scripts/
│   ├── 01_analyse_descriptive.R                    # Nettoyage, transformation
│   ├── 02_comportement_vs_gravite.R                # Analyse descriptive et bivariée
│   ├── 03_modelisation_ordinale.R                  # Ajustement du modèle ordinale
├── outputs/
│   ├── figures/                                    # Graphiques (histos, barplots...)                         


