## libs ----

library(tidyverse)


## nettoyage -----

# sources des fichiers
zip <- "https://www.data.gouv.fr/fr/datasets/r/b1711a83-19ee-4711-9f35-fa4e0095d7d6"

# chargement local
s <- read_csv("./data/StockEtablissement_utf8.csv")
n <- read.csv("./data/StockUniteLegale_utf8.csv")

n$siren <- as.character(n$siren)


# BDD 0 : light
table(s$etatadministratifetablissement) # A = 11166787, F = 16834869
table(is.na(s$etatadministratifetablissement)) # no NA

et2 <- et %>% filter(etatadministratifetablissement == "A",
                     trancheeffectifsetablissement != c("NN","00"))

# BDD : établissements
var_et <- c("siren", "nic", "libellepaysetrangeretablissement", "trancheeffectifsetablissement")

et_light <- et2 %>% select(var_et)

# BDD : unités
# trop lourd
# var_noms <- c("siren", "categorieentreprise", "denominationunitelegale","denominationusuelle1unitelegale","denominationusuelle2unitelegale","denominationusuelle3unitelegale", "categoriejuridiqueunitelegale","nomenclatureactiviteprincipaleunitelegale")

# version plus légère
var_noms <- c("siren", "categorieentreprise", "denominationunitelegale",
              "denominationusuelle1unitelegale")

u_light <- n %>% select(var_noms)

u_light$siren <- as.character(u_light$siren)

# sauvegarde des BDD light
write_csv(s2, "./data/sirene_light.csv")
write_csv(et_light, "./data/slight_et.csv")
write_csv(u_light, "./data/slight_u.csv")

## groupements par siren ----

et_light <- read_csv("./data/slight_eff.csv")
u_light <- read_csv("./data/slight_u.csv")

# première sélection simple : supérieur à 5000 par établissement
e_5000 <- et_light %>% filter(trancheeffectifsetablissement %in% c("52","53"),
                              is.na(libellepaysetrangeretablissement)) #tally() = 50

table(e_5000$trancheeffectifsetablissement) # 52 = 45, 53 = 5

e_5000FR <- left_join(e_5000, u_light, by = c("siren"="siren"))

nomsE5000 <- e_5000FR %>% filter(!is.na("denominationunitelegale") &&
                                   !is.na("denominationusuelle1unitelegale")) %>% 
  select(c("denominationunitelegale","denominationusuelle1unitelegale"))

nomsE5000 %>% group_by(denominationunitelegale) %>% 
  summarize(Etablissement = n()) %>% print(n = Inf) %>% write_delim("")

e_5000FR %>% group_by(denominationunitelegale) %>% 
  summarise(Etablisements = n()) %>% write_csv("./data_out/Et_sup_5000.csv")


## deuxème sélection par groupement

# j'ai complété le vecteur "tranches" pour intégrer les deux tranches supérieures
tranches <- c("01","02","03","11","12","21","22","31","32","41","42","51","52","53")
eff <- read_csv("./data/effectifs.csv")
names(eff)

# test sur un subset de 100k
effmin0 <- et_light[1:100000,] %>% filter(trancheeffectifsetablissement %in% tranches) %>% 
  filter(is.na(libellepaysetrangeretablissement)) %>% 
  group_by(siren,trancheeffectifsetablissement) %>%
  summarise(total = n()) %>%
  left_join(eff, by = c("trancheeffectifsetablissement" = "trancheEffectifsEtablissement")) %>% 
  # création d'une variable sur la base du minimum par tranche
  mutate(approx = total*min) %>% 
  group_by(siren) %>% 
  summarise(etablissements = n(), effectifmin = sum(approx))

effmin0 %>% filter(effectifmin >= 5000)

# sur la base entière
effmin <- et_light %>% filter(trancheeffectifsetablissement %in% tranches) %>% 
  filter(is.na(libellepaysetrangeretablissement)) %>% 
  group_by(siren,trancheeffectifsetablissement) %>%
  summarise(total = n()) %>%
  left_join(eff, by = c("trancheeffectifsetablissement" = "trancheEffectifsEtablissement")) %>% 
  # création d'une variable sur la base du minimum par tranche
  mutate(approx = total*min) %>% 
  group_by(siren) %>% 
  summarise(etablissements = n(), effectifmin = sum(approx))

# u_light$siren <- as.character(u_light$siren)

U_groupees <- effmin %>% filter(effectifmin >= 5000) %>% 
  left_join(u_light, by = c("siren"="siren"))

U_groupees %>% select(-c("categorieentreprise", "denominationusuelle1unitelegale")) %>% write_csv("./data_out/sirene_5000FR.csv")
U_groupees %>% filter(is.na(denominationunitelegale)) # 2 NA dans les dénominations légales
# 067800425 = ONET SERVICES
# 356000000 = LA POSTE

# alléger u_light : filter-out les entreprises "Cessées" ?