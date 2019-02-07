## libs ----

library(tidyverse)
library(xlsx)

## nettoyage -----

# sources des fichiers
zip <- "https://www.data.gouv.fr/fr/datasets/r/b1711a83-19ee-4711-9f35-fa4e0095d7d6"

# chargement local
et <- read_csv("./data/StockEtablissement_utf8.csv")
u <- read.csv("./data/StockUniteLegale_utf8.csv")

u$siren <- as.character(u$siren)
names(u)

# BDD 0 : light
table(s$etatadministratifetablissement) # A = 11166787, F = 16834869
table(is.na(s$etatadministratifetablissement)) # no NA

et2 <- et %>% filter(etatadministratifetablissement == "A",
                     trancheeffectifsetablissement != c("NN","00"))

# BDD : établissements
var_et <- c("siren", "nic", "libellepaysetrangeretablissement", "trancheeffectifsetablissement")

et_light <- et2 %>% select(var_et)

# BDD pour traitement noms
heads_et <- names(et)
save(heads_et, file = "./data/Headers_Et.Rdata")


var_et_noms <- c("siren", "nic", "libellepaysetrangeretablissement", "trancheeffectifsetablissement",
                 "denominationusuelleetablissement","enseigne1etablissement")

et_noms <- et2 %>% select(var_et_noms) %>% 
  filter(!is.na(denominationusuelleetablissement) | !is.na(enseigne1etablissement))

# BDD : unités légales

table(u$etatadministratifunitelegale)

u0 <- u %>% filter(sexeunitelegale == "", etatadministratifunitelegale == "A")

u0$siren <- as.character(u0$siren)

var_noms <- c("siren", "categorieentreprise", "denominationunitelegale",
              "denominationusuelle1unitelegale", "trancheeffectifsunitelegale")
u_light <- u0 %>% select(var_noms)

# BDD : catégories juridiques
var_jur <- c("siren","denominationunitelegale","denominationusuelle1unitelegale","categoriejuridiqueunitelegale")

u_jur <- u %>%  filter(sexeunitelegale == "", etatadministratifunitelegale == "A") %>% 
  select(var_jur)


# sauvegarde des BDD light
write_csv(et2, "./data/etActifs.csv")
write_csv(et_light, "./data/slight_et.csv")
write_csv(u_light, "./data/slight_u.csv")
write_csv(et_noms, "./data/slight_et_noms.csv")
write_csv(u_jur, "./data/u_juri.csv")


## groupements par siren ----

et_light <- read_csv("./data/slight_et.csv")
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
  summarize(Etablissement = n()) %>% print(n = Inf)

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

U_groupees <- effmin %>% filter(effectifmin >= 5000) %>% 
  left_join(u_light, by = c("siren"="siren"))

U_groupees %>% select(-c("categorieentreprise", "denominationusuelle1unitelegale")) %>% write_csv("./data_out/sirene_5000FR_et.csv")
U_groupees %>% filter(is.na(denominationunitelegale)) # 2 NA dans les dénominations légales
# 067800425 = ONET SERVICES
# 356000000 = LA POSTE

# alléger u_light : filter-out les entreprises "Cessées" ?

## établissements étrangers ------

et_light <- read_csv("./data/slight_et.csv")
u_light <- read_csv("./data/slight_u.csv")

# première sélection simple : supérieur à 5000 par établissement
et_light %>% filter(!is.na(libellepaysetrangeretablissement)) # n() = 0

## autres bases de calcul ----

et_light <- read_csv("./data/slight_et.csv")
u_light <- read_csv("./data/slight_u.csv")

tranches <- c("01","02","03","11","12","21","22","31","32","41","42","51","52","53")
eff <- read_csv("./data/effectifs.csv") %>% mutate(med = round((min+max)/2,0))

eff[14,"med"] <- 10000

# rappel : n(filter(effmin, approx >= 5000))  = 136

effmed <- et_light %>% filter(trancheeffectifsetablissement %in% tranches) %>% 
  filter(is.na(libellepaysetrangeretablissement)) %>% 
  group_by(siren,trancheeffectifsetablissement) %>%
  summarise(total = n()) %>%
  left_join(eff, by = c("trancheeffectifsetablissement" = "trancheEffectifsEtablissement")) %>% 
  # création d'une variable sur la base du minimum par tranche
  mutate(approx = total*med) %>% 
  group_by(siren) %>% 
  summarise(etablissements = n(), effectifmed = sum(approx))

effmed %>% filter(effectifmed >= 5000) # n() = 247

u_light$siren <- as.character(u_light$siren)

U_groupees_med <- effmed %>% filter(effectifmed >= 5000) %>% 
  left_join(u_light, by = c("siren"="siren"))

U_groupees_med %>% select(denominationunitelegale) %>% print(n = Inf)

## Traitement direct de la base unités légales -----
eff <- read_csv("./data/effectifs.csv")

names(u_light)

u_5000FR <- u_light %>% filter(trancheeffectifsunitelegale %in% c("52","53")) %>% 
  left_join(eff, by = (c("trancheeffectifsunitelegale"="trancheEffectifsEtablissement"))) %>% 
  select(siren,denominationunitelegale,min) %>% 
  mutate(siren = as.character(siren))

u_5000FR

u_5000FR %>% write_csv("./data_out/sirene_5000FR.csv")

## 

# source cat juridique : Insee / https://www.insee.fr/fr/information/2028129

u_5000FR <- read_csv("./data_out/sirene_5000FR.csv") %>% mutate(siren = as.character(siren))
u_jur <- read_csv("./data/u_juri.csv") %>%
  mutate(siren = as.character(siren),
         categoriejuridiqueunitelegale = as.character(categoriejuridiqueunitelegale))
cj <- as.tibble(read.xlsx("./data/cj_juillet_2018.xls", sheetIndex = 3, startRow = 4)) %>% 
  mutate(Code = as.character(Code), Libelle = noquote(as.character(Libellé))) %>% 
  select(-Libellé) %>% mutate(Libelle = as.character(Libelle))
# pourquoi ces quotes ?

u_5000_jur <- u_5000FR %>% left_join(u_jur, by = c("siren"="siren")) %>% 
  select(-denominationusuelle1unitelegale) %>% 
  mutate(categoriejuridiqueunitelegale = as.character(categoriejuridiqueunitelegale)) %>% 
  left_join(cj, by = c("categoriejuridiqueunitelegale" = "Code"))

u_5000_jur %>% filter(str_detect(categoriejuridiqueunitelegale,"^7")) # n() = 82
u_5000_jur %>% filter(!str_detect(categoriejuridiqueunitelegale,"^7")) # n() = 133
