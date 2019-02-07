## libs ----

library(tidyverse)
library(readxl)
library(xlsx)

## nettoyage -----

g <- read_csv("./data_out/greffe_5000FR.csv") %>%
  select(Siren,Dénomination,`Effectif 1`) %>% 
  setNames(c("siren","nom_greffe","effectif_greffe")) %>%
  mutate(siren = as.character((siren)))

s <- read_csv("./data_out/sirene_5000FR.csv") %>%
  setNames(c("siren","nom_sirene","effectif_sirene_min")) %>% 
  mutate(siren = as.character(siren))

## Sirene vs greffe
sgF <- full_join(s, g, by = "siren")
sgI <- inner_join(s, g, by = "siren") %>% mutate(delta = effectif_greffe - effectif_sirene_min,
         delta_ratio = (effectif_greffe - effectif_sirene_min)/effectif_sirene_min) %>% 
  arrange(desc(delta_ratio))

sgI %>% select(nom_sirene,delta_ratio) %>% print(n = Inf)

## orbis -----

# Orbis France
o <- read.xlsx("./data/Orbis_5000FR_21112018.xlsx", sheetIndex = 2) %>%
  select(Nom.de.l.entreprise,Effectifs.Dernière.année.disp.) %>% 
  setNames(c("nom_orbis","effectif_orbis"))

