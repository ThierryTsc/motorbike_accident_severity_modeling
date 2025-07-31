# ────────────────────────────────────────────────────────────────────────────────
# Analyse exploratoire initiale du dataset "MotorBike_Accident_Severity_Analysis"
# ────────────────────────────────────────────────────────────────────────────────
#
# 1. Chargement et nettoyage :
#    - Le jeu de données est importé avec `read_csv()` puis nettoyé avec `clean_names()` pour simplifier les noms de colonnes.
#    - Les colonnes catégorielles sont converties en facteurs, et `accident_severity` est ordonné selon la sévérité croissante.
library(tidyverse)
library(janitor)
library(skimr)

# Chargement et nettoyage des données
df <- read_csv("data/MotorBike_Accident_Severity_Analysis.csv") %>% 
  clean_names()

df <- df %>%
  mutate(
    accident_severity = factor(accident_severity,
                               levels = c("No Accident", "Moderate Accident", "Severe Accident"),
                               ordered = TRUE),
    wearing_helmet = factor(wearing_helmet),
    talk_while_riding = factor(talk_while_riding),
    smoke_while_riding = factor(smoke_while_riding),
    motorcycle_ownership = factor(motorcycle_ownership),
    valid_driving_license = factor(valid_driving_license),
    biker_education_level = factor(biker_education_level),
    biker_occupation = factor(biker_occupation),
    road_type = factor(road_type),
    road_condition = factor(road_condition),
    weather = factor(weather),
    time_of_day = factor(time_of_day),
    traffic_density = factor(traffic_density),
    biker_alcohol = factor(biker_alcohol),
    bike_condition = factor(bike_condition)
  )



# 2. Affichage répartition gravité
cat("Répartition des niveaux de gravité :\n")
df %>%
  count(accident_severity) %>%
  mutate(pourcentage = round(n / sum(n) * 100, 1)) %>%
  print()
# Répartition des niveaux de gravité d'accidents :
#    - 33.8 % des conducteurs n'ont eu **aucun accident**.
#    - 35.4 % ont eu un **accident modéré**.
#    - 30.8 % ont eu un **accident grave**.
#    - Seulement 2 cas avec `NA`, donc négligeables pour l’analyse.
#    → Le jeu est globalement bien équilibré entre les trois niveaux de gravité.



# 3. Statistiques descriptives variables numériques
cat("\nRésumé statistique des variables numériques :\n")
df %>%
  select(biker_age, riding_experience, daily_travel_distance, bike_speed, speed_limit, number_of_vehicles) %>%
  summary() %>%
  print()
#    - Âge moyen : ~36 ans, avec une majorité de conducteurs entre 24 et 49 ans.
#    - Expérience de conduite moyenne : ~7.5 ans, mais certains débutants (min = 0).
#    - Distance parcourue par jour : moyenne de 41 km, avec des cas extrêmes allant jusqu’à 150 km/jour.
#    - Vitesse moyenne des motos : 83 km/h, max observé à 120 km/h.
#    - Les vitesses limites sont cohérentes avec les normes routières (entre 40 et 80 km/h).
#    - L'échantillon contient en général 1 à 3 véhicules impliqués par accident.



# 4. Fréquences comportements à risque
cat("\nFréquences des comportements à risque :\n")
df %>%
  select(wearing_helmet, talk_while_riding, smoke_while_riding, biker_alcohol) %>%
  map(~ table(.) %>% prop.table() %>% round(2)) %>%
  print()
#    - 47 % des conducteurs **ne portent pas de casque**, ce qui est préoccupant.
#    - 43 % parlent parfois au téléphone en conduisant, 28 % régulièrement → usage du téléphone très répandu.
#    - 53 % fument **parfois** en roulant, et 7 % le font **régulièrement**.
#    - 17 % ont admis avoir **consommé de l’alcool** au volant → indicateur à croiser avec les accidents.


# Conclusion :
#    → Le dataset présente une grande diversité de comportements, avec des variables bien remplies et peu de valeurs manquantes.
#    → Les comportements à risque sont fréquents : absence de casque, téléphone, cigarette, alcool...
#    → Ces observations vont permettre d’explorer des relations entre comportements et gravité des accidents (analyses bivariées et modélisation ensuite).
