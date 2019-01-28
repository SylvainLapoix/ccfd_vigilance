## libs ----

library(tidyverse)


## nettoyage -----

# sources des fichiers : chiffres clefs 2017
url <- "https://opendata-infogreffe.com/explore/dataset/chiffres-cles-2017"

# chargement local
g <- read_csv2("./data/chiffres-cles-2017.csv")

table(is.na(g$`Millesime 1`))
g1 <- g %>% filter(!is.na(`Millesime 1`)) %>% 
  select(Dénomination,Siren,`Date immatriculation`,`Date radiation`,Statut,
         `Date de cloture exercice 1`,`Effectif 1`)

g5000 <- g1  %>% filter(`Effectif 1` >= 5000)
g5000 %>%  write_csv("./data_out/greffe_5000FR.csv")
