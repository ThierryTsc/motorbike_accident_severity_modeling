# ──────────────────────────────────────────────────────────────
# Étape 2 – Analyse bivariée
# Cette étape vise à explorer les associations entre certains comportements à risque
# (port du casque, usage du téléphone, alcool) et la gravité des accidents.
#
# Pour chaque variable :
# - on construit un tableau croisé avec `accident_severity` (fréquences + %),
# - on réalise un test du Chi² pour évaluer l’indépendance,
# - on visualise les proportions avec un barplot empilé.
#
# Ces analyses permettent d’identifier des variables candidates fortes pour une
# modélisation prédictive ultérieure.
# ──────────────────────────────────────────────────────────────

# ──────────────────────────────────────────────────────────────
# Fonction : analyse_bivariee()
# Paramètres :
# - data : le dataframe
# - var : nom de la variable catégorielle à comparer à accident_severity
# Effets :
# - Affiche le tableau croisé avec pourcentages,
# - Réalise un test du Chi²,
# - Affiche un barplot empilé
# ──────────────────────────────────────────────────────────────

analyse_bivariee <- function(data, var) {
  var_sym <- sym(var)
  
  cat("\n──────────────────────────────────────────────────\n")
  cat("Analyse de :", var, "vs accident_severity\n")
  cat("──────────────────────────────────────────────────\n\n")
  
  # Tableau croisé + pourcentages
  data %>%
    tabyl(!!var_sym, accident_severity) %>%
    adorn_percentages("row") %>%
    adorn_pct_formatting(digits = 1) %>%
    adorn_ns() %>%
    print()
  
  # Test du Chi²
  cat("\nTest du Chi² :\n")
  print(chisq.test(table(data[[var]], data$accident_severity)))
  
  # Barplot empilé
  ggplot(data, aes_string(x = var, fill = "accident_severity")) +
    geom_bar(position = "fill") +
    scale_y_continuous(labels = scales::percent) +
    labs(
      title = paste("Gravité de l'accident selon", var),
      x = var,
      y = "Proportion",
      fill = "Gravité"
    ) +
    theme_minimal() -> p
  print(p)
}

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

# ──────────────────────────────────────────────────────────────

# On teste ensuite cette fonction pour étudier l'influence des comportements (port du casque, 
# utilisation du téléphone, conduite sous alcool) sur la gravité des accidents

# ──────────────────────────────────────────────────────────────

analyse_bivariee(df, "wearing_helmet")
# Résultat de l’analyse bivariée : wearing_helmet vs accident_severity
# Les non-porteurs de casque présentent une légère surreprésentation
# dans les accidents modérés et graves.
#
# Le test du Chi² est significatif p-value ≈ 0.00008476 (p < 0.005), ce qui rejette l’hypothèse d’indépendance, 
#indiquant une association significative entre le port du casque et la gravité de l'accident.
#
# Les écarts de pourcentage restent faibles. Il conviendra d’intégrer
# cette variable dans une modélisation multivariée pour mieux juger
# de son impact réel (régression logistique ordonnée par exemple).

# ──────────────────────────────────────────────────────────────

analyse_bivariee(df, "talk_while_riding")
# Résultat de l’analyse bivariée : talk_while_riding vs accident_severity
# Les conducteurs qui utilisent régulièrement leur téléphone
# ont une probabilité très élevée d'accidents graves (68.2%).
#
# À l’inverse, ceux qui ne l’utilisent jamais sont plus
# répartis, avec une part importante de cas graves (40.8%).
#
# Les "Sometimes" sont surtout associés aux accidents modérés.
#
# Le test du Chi² est hautement significatif (p < 2.2e-16),
# ce qui confirme une forte association.
#
# ✅Cette variable est une excellente candidate pour un modèle prédictif,
# avec un effet probablement non linéaire.

# ──────────────────────────────────────────────────────────────


analyse_bivariee(df, "biker_alcohol")
# Le test du Chi² montre une association très significative 
# entre la consommation d'alcool et la gravité des accidents 
# (X² = 5388.6, ddl = 2, p-value < 2.2e-16).
#
# Lecture du tableau :
# - Les motards sobres (biker_alcohol = 0) sont majoritairement 
#   impliqués dans des accidents sans gravité ou modérés.
# - À l’inverse, les motards ayant consommé de l’alcool (biker_alcohol = 1)
#   sont surreprésentés dans les accidents graves : 92.3 % d'entre eux.
#
# Cette variable est donc fortement discriminante et sera pertinente 
# pour un futur modèle prédictif de la gravité des accidents.

