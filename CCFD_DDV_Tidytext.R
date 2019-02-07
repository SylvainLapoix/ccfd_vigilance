## libs ----

library(tidyverse)
library(tidytext)

## nettoyage ----

g <- read_csv("./data_out/greffe_5000FR.csv") %>%
  select(Siren,Dénomination,`Effectif 1`) %>% 
  setNames(c("siren","nom_greffe","effectif_greffe")) %>%
  mutate(siren = as.character((siren)))

s <- read_csv("./data_out/sirene_5000FR.csv") %>%
  setNames(c("siren","nom_sirene","effectif_sirene_min")) %>% 
  mutate(siren = as.character(siren))

