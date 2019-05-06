## libs ----

library(tidyverse)
library(xlsx)
library(viridis)
library(RColorBrewer)
library(ggrepel)

var_liste <- c("siren","nom","forme","effectif")

## Sirene ----

# Sirene : bases établissement ancien service https://www.data.gouv.fr/fr/datasets/base-sirene-des-entreprises-et-de-leurs-etablissements-siren-siret-fin-le-30-avril-2019/

# étape 1 : effectifs supérieurs à 5000 salariés cumulés

# dernier stock dispo 2017 assimilé 2018
var_stocket <- c("SIREN","NIC","NOMEN_LONG","SIEGE","TEFET","EFETCENT","NJ","LIBNJ","TEFEN","EFENCENT")

s2018 <- read_csv2("./data/sirene_stocket_201712.csv") %>%
  select(var_stocket) %>% filter(TEFEN %in% c("52","53"))

# dernier stock dispo 2016 assimilé 2017
s2017 <- read_csv2("./data/sirene_stocket_201612.csv") %>% 
  select(var_stocket) %>% filter(TEFEN %in% c("52","53"))

# constitution des lites
load("./data/sirene2018.Rdata")
load("./data/sirene2017.Rdata")

s2018_liste <- s2018 %>% group_by(SIREN, NOMEN_LONG, NJ,TEFEN, EFENCENT) %>% 
  summarise(e = n())

s2017_liste <- s2017 %>% group_by(SIREN, NOMEN_LONG, NJ,TEFEN, EFENCENT) %>% 
  summarise(e = n())

# étape 2 : vérification sur 2 années successives

s_liste <- s2018_liste %>% ungroup() %>%
  filter(SIREN %in% s2017_liste$SIREN) %>% 
  select(SIREN, NOMEN_LONG, NJ, EFENCENT) %>% 
  setNames(var_liste)

# fichiers light
save(s2018, file = "./data/sirene2018.Rdata")
save(s2017, file = "./data/sirene2017.Rdata")

# tri formes juridiques

# source catégories juridiques : Insee / https://www.insee.fr/fr/information/2028129

# exclusion des catégories 7 "Personne morale et organisme soumis au droit administratif" et 9 "Groupement de droit privé" (regroupant des ONGs)
s_liste_privees <- s_liste %>% filter(!(str_detect(forme,"^[79]")))

# quid des catégories 3 "Personne morale de droit étranger" ?
s_liste %>% filter(str_detect(forme,"^3")) # 8 entreprises

# quid des catégories 4 "Personne morale de droit public soumise au droit commercial" ?
s_liste %>% filter(str_detect(forme,"^4")) # 6 entreprises

write_csv(s_liste_privees, "./data_out/liste_sirene.csv")

# Analyse formes juridiques
s <- read_csv("./data_out/liste_sirene.csv", col_types =
                cols(siren = col_character(), nom = col_character(),
                     forme = col_character(),effectif = col_integer()))

cj1 <-  read.xlsx("./data/cj_juillet_2018.xls", sheetIndex = 1, startRow = 4,
                  as.data.frame=TRUE)

s_liste %>%  mutate(fj1 = gsub('.{3}$','',forme)) %>% 
  group_by(fj1) %>% summarise(n = n()) %>%
  left_join(cj1, by = c("fj1"="Code")) %>% arrange(desc(n))

s_liste %>%  mutate(fj1 = gsub('.{3}$','',forme)) %>% 
  filter(fj1 == "9")

head(cj1)

s_liste %>%  mutate(fj1 = gsub('.{3}$','',forme)) %>% 
  left_join(cj1, by = c("fj1"="Code")) %>% 
  ggplot(aes(label = Libellé)) +
  geom_bar(aes(x = fct_infreq(fj1), fill = fj1),color="grey50", size=0.2) +
  coord_flip() +
  theme(axis.title.y=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank(),
        panel.background = element_rect(fill = "#F1F1F1"),
        panel.grid.major = element_line(colour = "grey50", linetype="dashed"),
        legend.position="none") +
  scale_x_discrete(breaks = NULL) +
  labs(y = "Nombre d'entreprises répondant aux critères DDV (Insee)") +
  geom_label(aes(label = Libellé,x = fj1, y =0), size = 3, hjust="inward") +
  scale_fill_brewer(palette = "Greens")



s_liste %>%  mutate(fj1 = gsub('.{3}$','',forme)) %>% 
  filter(fj1 == "6")

## Infogreffe ----

# Infogreffe : chiffres clef 2018 https://opendata-infogreffe.com/explore/dataset/chiffres-cles-2018/
# Infogreffe : chiffres clef 2017 https://opendata-infogreffe.com/explore/dataset/chiffres-cles-2017/

g2018 <- read_csv2("./data/chiffres-cles-2018.csv")
g2017 <- read_csv2("./data/chiffres-cles-2017.csv")

# effectif supérieur à 5000 : base 2018 (fin 2018)
g2018 %>%  filter(!is.na(`Millesime 1`), !is.na(`Millesime 2`)) %>% 
  select(Siren,Dénomination,`Forme Juridique`,`Effectif 1`,`Effectif 2`) %>% 
  filter(`Effectif 1` >= 5000, `Effectif 2` >= 5000) # 5

# effectif supérieur à 5000 : base 2017 (fin 2017)
g_liste <- g2017 %>% filter(!is.na(`Millesime 1`), !is.na(`Millesime 2`)) %>% 
  select(Siren,Dénomination,`Forme Juridique`,`Effectif 1`,`Effectif 2`) %>% 
  filter(`Effectif 1` >= 5000, `Effectif 2` >= 5000) %>% # 52
  select(-`Effectif 2`) %>% setNames(var_liste)

# récupération des formes juridiques
s_juri <- read_csv2("./data/sirene_stocket_201712.csv") %>%
  select(SIREN,NJ)

# à alléger

write_csv(s_juri, "./data/sirene_formesjuridiques.csv")
s_juri <- read_csv("./data/sirene_formesjuridiques.csv")

s_juri <- s_juri %>% group_by(SIREN,NJ) %>% summarise(e = n()) %>% 
  select(-e) %>% ungroup()

g_liste_privees <- g_liste %>% left_join(s_juri, by = c("siren" = "SIREN")) %>% 
  mutate(forme = as.character(NJ)) %>% select(-NJ)

write_csv(g_liste_privees, "./data_out/liste_greffe.csv")

# tri forme social

g <- read_csv("./data_out/liste_greffe.csv", col_types =
                cols(siren = col_character(), nom = col_character(),
                     forme = col_character(),effectif = col_integer()))

g %>% mutate(fj1 = gsub('.{3}$','',forme)) %>% 
  group_by(fj1) %>% summarise(n = n()) # 52 entreprises de droit privé

# chargement des formes juridiques Insee niveau 3
cj3 <- read.xlsx("./data/cj_juillet_2018.xls", sheetIndex = 3, startRow = 4,
                 as.data.frame=TRUE)

head(cj3)
g %>% left_join(cj3, by = c("forme"="Code")) %>% group_by(forme, Libellé) %>% 
  summarise(n = n()) %>% arrange(desc(n))

g %>% left_join(cj3, by = c("forme"="Code")) %>% 
  ggplot(aes(label = Libellé)) +
  geom_bar(aes(x = fct_rev(fct_infreq(forme)), fill = forme)) +
  coord_flip() +
  theme(axis.title.y=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank(),
        panel.background = element_rect(fill = "#F1F1F1"),
        panel.grid.major = element_line(colour = "grey50", linetype="dashed"),
        legend.position="none") +
  scale_x_discrete(breaks = NULL) +
  labs(y = "Nombre d'entreprises répondant aux critères DDV") +
  geom_label(aes(label = Libellé,x = forme, y =0), size = 3, hjust="inward") +
  scale_fill_brewer(palette = "Oranges")

## Recoupements Greffe et Insee ----

names(s)

sg <- merge(s,g, by = "siren", all = FALSE) # 45

anti_join(s,g,by="siren") # 91
anti_join(g,s,by="siren") # 7

# venneuler s et g
library(eulerr)

vd <- euler(c(sirene=136,greffe=52,"sirene&greffe"=45))
plot(vd, key = TRUE, quantities = TRUE)

?venneuler

## Orbis ----
s <- read_csv("./data_out/liste_sirene.csv", col_types =
                cols(siren = col_character(), nom = col_character(),
                     forme = col_character(),effectif = col_integer()))
g <- read_csv("./data_out/liste_greffe.csv", col_types =
                cols(siren = col_character(), nom = col_character(),
                     forme = col_character(),effectif = col_integer()))



oFR <- read.xlsx("./data/Orbis_5000FR_21112018.xlsx", sheetIndex = 2) %>%
  select(Nom.de.l.entreprise,Effectifs.Dernière.année.disp.) %>% 
  setNames(c("nom","effectif_orbis")) %>% 
  mutate(nom = as.character(nom))

oWW <- read.xlsx("./data/Orbis_10000WW_21112018.xlsx", sheetIndex = 2) %>%
  select(Nom.de.l.entreprise,Effectifs.Dernière.année.disp.) %>% 
  setNames(c("nom","effectif_orbis")) %>% 
  distinct(nom) %>% # retirer le doublon "FRANCE TELEVISIONS"
  mutate(nom = as.character(nom))


merge(oFR,oWW, by = "nom", all = FALSE) # 146
anti_join(oFR,oWW, by = "nom") # 91

# comparaisons Orbis / S / G

merge(s,oFR, by="nom") %>% tally() # 69
merge(g,oFR, by="nom") %>% tally() # 39
intersect(intersect(s$nom,g$nom),oFR$nom) # 31
merge(s,g, by="nom") # 33 entreprises, soit 12 de moins qu'avec siren

# venneuler s et g
library(eulerr)

vd <- euler(c(sirene=136,greffe=52, orbis=259,
              "sirene&orbis"=69,"greffe&orbis"=39,
              "sirene&greffe&orbis"=31,
              "sirene&greffe"=33))
plot(vd, key = TRUE, quantities = TRUE)

## liste CCFD + Sherpa ----

# comparaisons CCFD + Sherpa / S / G

## liste déf

sg <- merge(s,g, by = "siren", all = FALSE) # 45

sg %>% select(-c(nom.y,forme.y)) %>%
  setNames(c("siren","nom","forme","effectifSirene","effectifGreffe")) %>% 
  arrange(-desc(nom)) %>% 
  select(nom, siren) %>% write_csv("./data_out/liste_s&g.csv")
