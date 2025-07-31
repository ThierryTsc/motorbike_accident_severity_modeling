# ──────────────────────────────────────────────────────────────
# Étape 3 – Modélisation logistique ordinale
#
# Objectif général :
# On souhaite modéliser la gravité des accidents (variable ordinale à 3 niveaux :
# "No Accident", "Moderate Accident", "Severe Accident") en fonction de plusieurs
# comportements à risque et caractéristiques du biker.
#
# Pourquoi un modèle logistique ordinale ?
# - Parce que la variable cible (accident_severity) est qualitative ordonnée,
#   ce qui exclut les modèles linéaires classiques.
# - Le modèle `polr()` (proportional odds logistic regression) permet d’estimer
#   l’effet des variables explicatives sur la probabilité que la gravité soit
#   au moins d’un certain niveau.
# 
# Ce script ne fait que préparer les données en :
# - Nettoyant les variables nécessaires,
# - Corrigeant les niveaux de la variable cible,
# - Sélectionnant les variables pertinentes identifiées à l’étape bivariée,
# - Supprimant les lignes incomplètes.
#
# Le jeu de données final `df_model` sera utilisé dans le script suivant
# pour ajuster et interpréter un modèle logistique ordinale avec `polr()`.
# ──────────────────────────────────────────────────────────────

library(tidyverse)
library(janitor)
library(MASS)

# Chargement et nettoyage de base
df <- read_csv("data/MotorBike_Accident_Severity_Analysis.csv") %>%
  clean_names()

# Correction des niveaux de la variable cible (ordre croissant de gravité)
df <- df %>%
  mutate(
    accident_severity = factor(accident_severity,
                               levels = c("No Accident", "Moderate Accident", "Severe Accident"),
                               ordered = TRUE),
    
    # Transformation en facteurs des variables qualitatives utiles
    wearing_helmet = factor(wearing_helmet),
    talk_while_riding = factor(talk_while_riding),
    smoke_while_riding = factor(smoke_while_riding),
    biker_alcohol = factor(biker_alcohol),
    valid_driving_license = factor(valid_driving_license),
    biker_education_level = factor(biker_education_level),
    road_condition = factor(road_condition)
  )

# Sélection des variables à inclure dans le modèle
df_model <- df %>%
  dplyr::select(
    accident_severity,        # Variable à prédire
    wearing_helmet,
    talk_while_riding,
    smoke_while_riding,
    biker_alcohol,
    riding_experience,        # Variable numérique
    bike_speed                # Variable numérique
  ) %>%
  drop_na()  # Suppression des lignes avec valeurs manquantes

# Vérification rapide des données prêtes à modéliser
summary(df_model)

# ──────────────────────────────────────────────────────────────
# Étape 4 – Ajustement d’un modèle logistique ordinale
#
# Objectif : prédire la gravité d’un accident (No, Moderate, Severe)
# en fonction de comportements à risque et caractéristiques du conducteur.
#
# Modèle utilisé : polr() du package MASS (logistique ordinale à odds proportionnelles)
# ──────────────────────────────────────────────────────────────


library(broom)   # pour tidy(), augment(), glance()
library(dplyr)

# Ajustement du modèle
mod_polr <- polr(
  accident_severity ~ wearing_helmet +
    talk_while_riding +
    smoke_while_riding +
    biker_alcohol +
    riding_experience +
    bike_speed,
  data = df_model,
  Hess = TRUE  # important pour avoir l'information de variance-covariance
)

# Résumé brut du modèle
summary(mod_polr)

# Extraction des coefficients + valeurs p (approximatives)
# On utilise `tidy()` du package broom
mod_polr_tidy <- tidy(mod_polr)

# Affichage des coefficients et intervalles de confiance
print(mod_polr_tidy)

# Calcul des p-values via un test de Wald
# (approximatif car polr ne donne pas directement les p-values)
mod_polr_tidy <- mod_polr_tidy %>%
  mutate(p_value = 2 * (1 - pnorm(abs(statistic))))

# Résultats complets : coefficient, sens de l’effet, IC95%, p-value
print(mod_polr_tidy)

# ────────────────────────────────────────────────
# Interprétation des résultats du modèle polr()
# ────────────────────────────────────────────────
# Les coefficients estimés représentent l'effet de chaque variable
# explicative sur la probabilité de se retrouver dans une catégorie
# plus sévère d'accident.
#
# Un coefficient positif → augmente la probabilité d'un accident plus grave.
# Un coefficient négatif → diminue cette probabilité.
#
# Les p-values (test de Wald) indiquent si l'effet est significatif :
# - p < 0.05 → effet significatif
# - p ≈ 0 → effet très significatif
#
# Exemple d'interprétation :
# - "bike_speed" a un effet positif et très significatif :
#     → plus la vitesse est élevée, plus la gravité de l’accident augmente.
# - "riding_experience" a un effet négatif significatif :
#     → plus un conducteur a d'expérience, moins il risque un accident grave.
#
# Attention : certains effets extrêmes comme "smoke_while_ridingRegularly"
# (coefficient ≈ 16) peuvent indiquer un problème de rareté des données ou
# de séparabilité parfaite.

