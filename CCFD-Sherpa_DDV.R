## libs ----

library(tidyverse)
library(xlsx)
library(tidytext)
library(openxlsx)

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


# étape 2 : vérification sur 2 années successives

s_liste <- s2018_liste %>% ungroup() %>%
  filter(SIREN %in% s2017_liste$SIREN) %>% 
  select(SIREN, NOMEN_LONG, NJ, EFENCENT) %>% 
  setNames(var_liste)

# fichiers light
save(s2018, file = "./data/sirene2018.Rdata")
save(s2017, file = "./data/sirene2017.Rdata")



## Analyse formes juridiques ----
s2018_liste <- s2018 %>% group_by(SIREN, NOMEN_LONG, NJ,TEFEN, EFENCENT) %>%
  summarise(e = n())

s2017_liste <- s2017 %>% group_by(SIREN, NOMEN_LONG, NJ,TEFEN, EFENCENT) %>%
  summarise(e = n())

s_liste <- s2018_liste %>% ungroup() %>%
  filter(SIREN %in% s2017_liste$SIREN) %>% 
  select(SIREN, NOMEN_LONG, NJ, EFENCENT) %>% 
  setNames(var_liste)

# ajout d'une variable "DDV" suivant les formes concernées par la loi :
# sociétés anonymes (SA - 55 et 56)
# sociétés européennes (SE - 58)
# sociétés par actions simplifiées (SAS -57)
# sociétés en commandite par actions (SCA - 5308).
s_liste <- s_liste %>%
  mutate(ddv = case_when(forme == "5308" ~ TRUE,
                         str_detect(forme,"^5[5-8]") ~ TRUE,
                         TRUE ~ FALSE))

save(s_liste, file = "./data/liste_sirene-brute.Rdata")

# constitution liste Sirene filtrée

s_liste %>% filter(ddv == TRUE) %>% select(-ddv) %>% 
  write_csv("./data_out/liste_sirene.csv")

# chargement des formes juridiques Insee

# source catégories juridiques : Insee / https://www.insee.fr/fr/information/2028129
cj1 <-  read.xlsx("./data/cj_juillet_2018.xls", sheetIndex = 1,
                  startRow = 4,as.data.frame=TRUE) %>%
  mutate(Code = as.character(Code))

cj2 <- read.xlsx("./data/cj_juillet_2018.xls", sheetIndex = 2, startRow = 3,
                 as.data.frame=TRUE) %>%
  mutate(Code = as.character(Code))

cj3 <- read.xlsx("./data/cj_juillet_2018.xls", sheetIndex = 3, startRow = 3,
                 as.data.frame=TRUE) %>%
  mutate(Code = as.character(Code))

# Dataviz
load("./data/liste_sirene-brute.Rdata")

# couleurs : vert "#81Af75", rouge "#BE1A40", bleu background "#CBD8EB"

s_liste %>%  mutate(fj1 = gsub('.{3}$','',forme)) %>% 
  left_join(cj1, by = c("fj1"="Code")) %>% 
  mutate(ddv = case_when(fj1 %in% c("7","9") ~ FALSE, TRUE ~ TRUE)) %>%
  ggplot() +
  geom_bar(aes(x = fct_infreq(fj1), fill = ddv)) +
    coord_flip() +
  theme(axis.title.y=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank(),
        panel.background = element_rect(fill = "white"),
        plot.background = element_rect(fill = "#CBD8EB"),
        panel.grid.major = element_line(colour = "grey50", linetype="dashed"),
        legend.position="none") +
  scale_x_discrete(breaks = NULL) +
  labs(y = "Nombre d'entreprises répondant aux critères DDV (Insee)") +
  scale_fill_manual(breaks = c(TRUE,FALSE),
                    values=c("#BE1A40","#81Af75")) +
  geom_text(aes(label = Libellé, x = fj1, y= 0),
            size = 4, colour = "black",family="Helvetica")

# strwrap pour les noms de formes juridiques

s <- read_csv("./data_out/liste_sirene.csv", col_types =
                cols(siren = col_character(), nom = col_character(),
                     forme = col_character(),effectif = col_integer()))

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
s_juri <- read_csv("./data/sirene_formesjuridiques.csv") %>%
  group_by(SIREN,NJ) %>% summarise(e = n()) %>% 
  select(-e) %>% ungroup()

# ajout d'une variable "DDV" suivant les formes concernées par la loi
g_liste <- g_liste %>%
  left_join(s_juri, by = c("siren" = "SIREN")) %>% 
  mutate(forme = as.character(NJ)) %>% select(-NJ) %>%
  mutate(ddv = case_when(forme == "5308" ~ TRUE,
                         str_detect(forme,"^5[5-8]") ~ TRUE,
                         TRUE ~ FALSE))

save(g_liste, file = "./data/liste_greffe-brute.Rdata")

g_liste_ddv <- g_liste %>% filter(ddv == TRUE) %>% select(-ddv)

write_csv(g_liste_ddv, "./data_out/liste_greffe.csv")

# tri forme social
g <- read_csv("./data_out/liste_greffe.csv", col_types =
                cols(siren = col_character(), nom = col_character(),
                     forme = col_character(),effectif = col_integer()))

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

g %>% filter(!(forme %in% c("5202","5499"))) %>% 
  mutate(fj2 = gsub('.{2}$','',forme)) %>% 
  left_join(cj2, by = c("fj2"="Code")) %>%
  group_by(fj2,Libellé) %>% summarise(n = n())
  
g %>% left_join(cj3, by = c("forme"="Code")) %>% 
  group_by(forme,Libellé) %>% summarise(n = n())

g %>% filter(forme %in% c("5202","5499")) %>% 
  left_join(cj3, by = c("forme"="Code"))


## Recoupements Greffe et Insee ----

# vérification nom
sg <- merge(s,g, by = "siren", all = FALSE) # 44

head(sg)

sg %>% filter(nom.x != toupper(nom.y)) %>% select(nom.x,nom.y) %>% 
  setNames(c("nom_siren","nom_greffe"))

anti_join(s,g,by="siren") # 69
anti_join(g,s,by="siren") # 5

# venneuler s et g
library(eulerr)

vd <- euler(c(sirene=113,greffe=49,"sirene&greffe"=44))
plot(vd, key = TRUE, quantities = TRUE)

?venneuler

## BDDs S, G, O ----
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


merge(oFR,oWW, by = "nom", all = FALSE) # 145
anti_join(oFR,oWW, by = "nom") # 114

# comparaisons Orbis / S / G

merge(s,oFR, by="nom") %>% tally() # 69
merge(g,oFR, by="nom") %>% tally() # 39
intersect(intersect(s$nom,g$nom),oFR$nom) # 31
merge(s,g, by="nom") # 33 entreprises, soit 12 de moins qu'avec siren

sg <- merge(s,g, by = "siren", all = FALSE) %>% 
  select(siren,nom.x,forme.x,effectif.x,effectif.y) %>% 
  setNames(c("siren","nom","forme","effectif_sirene","effectif_greffe"))

intersect(sg$nom,oFR$nom)


# venneuler s, g et o
library(eulerr)

vd <- euler(c(sirene=136,greffe=52, orbis=259,
              "sirene&orbis"=69,"greffe&orbis"=39,
              "sirene&greffe&orbis"=37,
              "sirene&greffe"=45))
plot(vd, key = TRUE, quantities = TRUE)

## liste CCFD + Sherpa ----

ccfdsherpa <- read_csv("./data_out/liste_ccfd-sherpa.csv")


## correction manuelle des bases -----
# siren : nouvaux noms
s <- s %>% mutate(nom = case_when(siren == "383470937" ~ "THALES SIX GTS FRANCE SAS",
                                  siren == "399315613" ~ "METRO FRANCE",
                                  siren == "410409460" ~ "AUCHAN HYPERMARCHE",
                                  siren == "855200507" ~ "MANUFACTURE FRANCAISE DES PNEUMATIQUES MICHELIN",
                                  TRUE ~ nom))

# greffe : noms comptacts
g <- g %>% mutate(nom = case_when(siren == "440283752" ~ "CSF",
                                  siren == "775726417" ~ "KPMG",
                                  siren == "775733835" ~ "MAJ",
                                  TRUE ~ toupper(nom)))

# vérification
merge(s,g, by = "siren") %>% filter(nom.x != nom.y)

ccfdsherpa %>% filter(str_detect(nom,"LA POSTE"))

# ccfd sherpa
ccfdsherpa <- ccfdsherpa %>%
  mutate(nom = case_when(siren == "552043002" ~ "AIR FRANCE - KLM",
                         siren == "552096281" ~ "L'AIR LIQUIDE SOCIETE ANONYME POUR L'ETUDE ET L'EXPLOITATION DES PROCEDES GEORGES CLAUDE",
                         siren == "542094065" ~ "SOCIETE ANONYME DES GALERIES LAFAYETTE",
                         siren == "554501171" ~ "CASINO GUICHARD-PERRACHON",
                         siren == "356000000" ~ "LA POSTE",
                         str_detect(nom,"MICHELIN") ~
                           "COMPAGNIE GENERALE DES ETABLISSEMENTS MICHELIN (C.G.E.M.)",
                         TRUE ~ toupper(nom)))

ccfdsherpa %>% filter(str_detect(nom,"MICHELIN"))

merge(s,oFR, by="nom") %>% tally() # 69
merge(g,oFR, by="nom") %>% tally() # 44
merge(ccfdsherpa,oFR, by="nom") %>% tally() # 31

## comparaisons CS / S / G -----

# source filter function:
# https://cran.r-project.org/web/packages/dplyr/vignettes/programming.html
# https://stackoverflow.com/questions/48016468/make-a-function-to-filter-and-summarize-using-r

ddv_filter <- function(var,arg){
  var <- enquo(var)
  if (nrow(filter(s,str_detect(!! var,arg))) == 0){
    s1 <- as.data.frame(list(nom = arg,source="Sirene",
                          nom_source=NA,siren=NA))
  } else {
    s1 <- s %>% filter(str_detect(nom,arg)) %>%
      select(nom, siren) %>% setNames(c("nom_source","siren")) %>% 
      mutate(nom = arg,source = "Sirene") %>% 
      select(nom, source,nom_source,siren)
  }
  if (nrow(filter(g,str_detect(!! var,arg))) == 0){
    g1 <- as.data.frame(list(nom = arg,source="Greffe",
                             nom_source=NA,siren=NA))
  } else {
    g1 <- g %>% filter(str_detect(nom,arg)) %>%
      select(nom, siren) %>% setNames(c("nom_source","siren")) %>% 
      mutate(nom = arg,source = "Greffe") %>% 
      select(nom, source,nom_source,siren)
  }
  if (nrow(filter(oFR,str_detect(!! var,arg))) == 0){
    o1 <- as.data.frame(list(nom = arg,source="Orbis",
                             nom_source=NA,siren=NA))
  } else {
    o1 <- oFR %>% filter(str_detect(nom,arg)) %>%
      select(nom) %>% setNames(c("nom_source")) %>% 
      mutate(nom = arg,source = "Orbis",siren=NA) %>% 
      select(nom, source,nom_source,siren)
  }
  return(rbind(s1,g1,o1))
}

# test
ddv_filter(nom,"RENAULT")

# constitution de la liste comparative
comparo <- setNames(data.frame(matrix(ncol = 4, nrow = 0)),
                    c("nom", "source", "nom_source","siren"))

for (i in ccfdsherpa) {
    ddv <- ddv_filter(nom,i)
    comparo <- rbind(comparo, as.data.frame(ddv))
  }

write_csv(comparo, "./data_out/listecroisee_CCFDSherpa.csv")

# pour vérification des "nuls"
s2018_complete <- read_csv2("./data/sirene_stocket_201712.csv") %>%
  select(c("SIREN","NIC","NOMEN_LONG","TEFET","EFETCENT",
           "NJ","LIBNJ","TEFEN","EFENCENT"))

save(s2018_complete, file = "./data/sirene_201712_light.Rdata")

## comparo S/G/CS - Orbis -----

ddv_filter2 <- function(var,arg){
  var <- enquo(var)
  if (nrow(filter(s,str_detect(!! var,arg))) == 0){
    s1 <- as.data.frame(list(nom = arg,source="Sirene",
                             nom_source=NA,siren=NA))
  } else {
    s1 <- s %>% filter(str_detect(nom,arg)) %>%
      select(nom, siren) %>% setNames(c("nom_source","siren")) %>% 
      mutate(nom = arg,source = "Sirene") %>% 
      select(nom, source,nom_source,siren)
  }
  if (nrow(filter(g,str_detect(!! var,arg))) == 0){
    g1 <- as.data.frame(list(nom = arg,source="Greffe",
                             nom_source=NA,siren=NA))
  } else {
    g1 <- g %>% filter(str_detect(nom,arg)) %>%
      select(nom, siren) %>% setNames(c("nom_source","siren")) %>% 
      mutate(nom = arg,source = "Greffe") %>% 
      select(nom, source,nom_source,siren)
  }
  if (nrow(filter(ccfdsherpa,str_detect(!! var,arg))) == 0){
    cs1 <- as.data.frame(list(nom = arg,source="CCFD",
                             nom_source=NA,siren=NA))
  } else {
    cs1 <- ccfdsherpa %>% filter(str_detect(nom,arg)) %>%
      select(nom,siren) %>% setNames(c("nom_source","siren")) %>% 
      mutate(nom = arg,source = "CCFD") %>% 
      select(nom, source,nom_source,siren)
  }
  return(rbind(s1,g1,cs1))
}

ddv_filter2(nom,"MICHELIN") %>% filter(source == "CCFD")

o %>% filter(str_detect(nom,"MICHELIN"))
oFR %>% filter(str_detect(nom,"H&M"))


# nettoyage d'orbis
o <- oFR %>%
  # retrait des SARL connues
  filter(!(nom %in% c("ZARA FRANCE","SECURITAS FRANCE SARL","H&M HENNES & MAURITZ"))) %>% 
  mutate(nom = case_when(str_detect(nom,"^GROUPE") ~ gsub("GROUPE\ ","",nom),
                        str_detect(nom,"\ S.?A.?S?$") ~ str_replace(nom,"\ S.?A.?S?$",""),
                        str_detect(nom,"\ SE$") ~ str_replace(nom,"\ SE$",""),
                        str_detect(nom,"\ FRANCE$") ~ str_replace(nom,"\ FRANCE$",""),
                        TRUE ~ nom)) %>% 
  # cas particuliers
  mutate(nom = case_when(nom =="AUCHAN SUPERMARCHE" ~ "AUCHAN HYPERMARCHE",
                         nom == "COMPAGNIE DE SAINT GOBAIN" ~ "COMPAGNIE DE SAINT-GOBAIN",
                         nom == "ESSILOR INTERNATIONAL (COMPAGNIE GENERALE D'OPTIQUE)" ~ "ESSILOR",
                         nom == "DU LOUVRE" ~ "GROUPE DU LOUVRE",
                         nom == "ORANO CYCLE" ~ "ORANO",
                         TRUE ~ nom))
o <- oFR


## constitution bdd de test orbis -----
check_orbis <- setNames(data.frame(matrix(ncol = 4, nrow = 0)),
                    c("nom", "source", "nom_source","siren"))

for (i in o$nom) {
  ddv <- ddv_filter2(nom,i)
  check_orbis <- rbind(check_orbis, as.data.frame(ddv))
}

# liste complète
write_csv(check_orbis, "./data_out/liste_check-orbis.csv")

# liste match
check_orbis %>% filter(!is.na(nom_source)) %>% 
  write_csv("./data_out/liste_orbis-v1.csv")

# liste sans match
check_orbis %>% filter(is.na(nom_source)) %>% 
  group_by(nom) %>% summarise(n = n()) %>% filter(n == 3) %>% 
  select(nom) %>% write_csv("./data_out/orbis_out.csv")

check_orbis %>% filter(str_detect(nom,"MICHELIN"))

check_orbis %>% filter(str_detect(nom,"KLM"))

oFR %>% filter(str_detect(nom,"LOUVRE"))

# version xlsx
OUT <- createWorkbook()
addWorksheet(OUT, "Liste_Orbis")
addWorksheet(OUT, "Liste_Orbis-matchs")
addWorksheet(OUT, "Liste_Orbis-nomatch")
writeData(OUT, sheet="Liste_Orbis", x = check_orbis)
writeData(OUT, sheet="Liste_Orbis-matchs", x = filter(check_orbis, !is.na(nom_source)))
writeData(OUT, sheet="Liste_Orbis-nomatch", x = filter(check_orbis, is.na(nom_source)) %>%
            group_by(nom) %>% summarise(n = n()) %>% filter(n == 3) %>% select(nom))
saveWorkbook(OUT, "./data_out/liste_orbis.xlsx")
??writeData

# Write the data to the sheets
writeData(OUT, sheet = "Sheet 1 Name", x = dataframe1)
writeData(OUT, sheet = "Sheet 2 Name", x = dataframe2)

# Reorder worksheets
worksheetOrder(OUT) <- c(2,1)

# Export the file
saveWorkbook(OUT, "My output file.xlsx")

## liste def ------
sg <- merge(s,g, by = "siren", all = FALSE) # 45

sg %>% select(-c(nom.y,forme.y)) %>%
  setNames(c("siren","nom","forme","effectifSirene","effectifGreffe")) %>% 
  arrange(-desc(nom)) %>% 
  select(nom, siren) # %>% write_csv("./data_out/liste_s&g.csv")
