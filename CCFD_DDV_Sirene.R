library(tidyverse)

eff <- read_csv("data/trancheEffectifsEtablissement.csv")
s <- read_csv("data/StockEtablissement_utf8.csv")
headers <- read_csv("data/headers.csv")

names(s)

## nettoyage -----

# BDD 0 : light
table(s$etatadministratifetablissement) # A = 11166787, F = 16834869
table(is.na(s$etatadministratifetablissement)) # no NA

s2 <- s %>% filter(etatadministratifetablissement == "A",
                   trancheeffectifsetablissement != c("NN","00"))

# BDD 1 : ref effectifs
var_eff <- c("siren", "nic", "libellepaysetrangeretablissement", "trancheeffectifsetablissement")

e_eff <- s2 %>% select(var_eff)

# BDD 2 : ref noms
var_noms <- c("siren", "nic", "enseigne1etablissement", "enseigne2etablissement", "enseigne3etablissement",
             "denominationusuelleetablissement")

e_noms <- s2 %>% select(var_noms)

# sauvegarde des BDD light
write_csv(s2, "./data/sirene_light.csv")
write_csv(e_eff, "./data/slight_eff.csv")
write_csv(e_noms, "./data/slight_noms.csv")

## groupement ----
e_eff <- read_csv("./data/slight_eff.csv")
e_noms <- read_csv("./data/slight_noms.csv")