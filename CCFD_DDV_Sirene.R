## libs ----

library(tidyverse)

# s <- read_csv("data/StockEtablissement_utf8.csv")
eff <- read_csv("data/effectifs.csv")

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

## groupements par siren ----
e_eff <- read_csv("./data/slight_eff.csv")
e_noms <- read_csv("./data/slight_noms.csv")

# première sélection simple : supérieur à 5000 par établissement
e_5000FR <- e_eff %>% filter(trancheeffectifsetablissement %in% c("52","53"),
                             is.na(libellepaysetrangeretablissement)) #tally() = 50

table(e_5000$trancheeffectifsetablissement) # 52 = 45, 53 = 5

names(e_noms)

e_5000FR <- left_join(e_5000, e_noms, by = c("siren"="siren", "nic"="nic"))
nomsE5000 <- e_5000FR %>% filter(!is.na(enseigne1etablissement)) %>% select(enseigne1etablissement) # tally() = 23
e_5000FR %>% filter(!is.na(denominationusuelleetablissement)) # tally() = 1

nomsE5000 %>% tbl_df() %>% print(n = Inf)

# d'où vient le problème de non renseignement ? Problème dans le left_join() ?

# deuxème sélection par groupement
e_eff %>% filter(trancheeffectifsetablissement %in% c("01","02","03","11","12","21","22","31","32","41","42","51")) %>% 
  group_by(siren,trancheeffectifsetablissement,libellepaysetrangeretablissement) %>% 
  summarise(total = n())

