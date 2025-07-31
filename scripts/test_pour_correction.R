library(tidyverse)
library(janitor)

# Chargement et nettoyage
df <- read_csv("data/MotorBike_Accident_Severity_Analysis.csv") %>% 
  clean_names()

# Que contient réellement la colonne ?
unique(df$accident_severity)

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


table(df$accident_severity, useNA = "always")
