## libs ----

library(tidyverse)

## nettoyage -----

g <- read_csv("./data_out/greffe_5000FR.csv")
s <- read_csv("./data_out/sirene_5000FR.csv")

# WARNING : siren lu comme <dbl>
g$Siren <- as.character(g$Siren)

g0 <- g %>% select(Dénomination,Siren,`Effectif 1`) %>% 
  setNames(c("nom_greffe","siren","effectif_greffe"))

s0 <- s %>% select(denominationunitelegale,siren,effectifmin) %>% 
  setNames(c("nom_sirene","siren","effectif_sirene_min"))

# comparer les listes de siren
# jointures : left ? right ? full ?