En cours.

## Sources

Primaires :
* Sirene, stock établissements au 01/2019 : https://www.data.gouv.fr/fr/datasets/r/d9c12e7e-6a9d-4564-a846-86b8b563a477 (as "./data/StockEtablissement_utf8.csv") ;

Secondaires :
* BDD des tranches d'effectifs sur la base de la doc (as "./data/effectifs.csv")

## Etat des recherches

### Première approche : recherches d'établissements de plus de 5000 salariés en France
Le premier tri vise à identifier les entreprises comportant au moins un établissement basé en France disposant d'un effectif supérieur à 5000 salariés (valeurs de tranche d'effectif 52 ou 53).

Ce tri permet l'identification de 45 unités légales, dont deux (PSA Automobiles SA et APHP) disposant de trois établissements à plus de 5000 salariés.

La liste complète est fourni ci-dessous et stockée dans [Et_sup_5000.csv]("./data_out/Et_sup_5000.csv") :


| denominationunitelegale                                         | Etablisements | 
|-----------------------------------------------------------------|---------------| 
| AIRBUS                                                          | 1             | 
| AIRBUS HELICOPTERS                                              | 1             | 
| AIRBUS OPERATIONS                                               | 1             | 
| ALTEN                                                           | 1             | 
| ASSISTANCE PUBLIQUE HOPITAUX DE PARIS                           | 3             | 
| AXA FRANCE IARD                                                 | 1             | 
| CENTRE HOSPITALIER REGIONAL DE MARSEILLE                        | 1             | 
| CENTRE HOSPITALIER REGIONAL DE NANCY                            | 1             | 
| CENTRE HOSPITALIER REGIONAL UNIVERSITAIRE                       | 1             | 
| CENTRE HOSPITALIER UNIVERSITAIRE                                | 2             | 
| CENTRE HOSPITALIER UNIVERSITAIRE D'ANGERS                       | 1             | 
| CENTRE HOSPITALIER UNIVERSITAIRE DE BORDEAUX                    | 1             | 
| CENTRE HOSPITALIER UNIVERSITAIRE DE CAEN NORMANDIE              | 1             | 
| CENTRE HOSPITALIER UNIVERSITAIRE DE DIJON                       | 1             | 
| CENTRE HOSPITALIER UNIVERSITAIRE DE LILLE                       | 1             | 
| CENTRE HOSPITALIER UNIVERSITAIRE DE POITIERS                    | 1             | 
| CENTRE HOSPITALIER UNIVERSITAIRE DE TOULOUSE                    | 1             | 
| CENTRE HOSPITALIER UNIVERSITAIRE GRENOBLE ALPES                 | 1             | 
| CENTRE HOSPITALIER UNIVERSITAIRE ROUEN                          | 1             | 
| CHU NANTES                                                      | 1             | 
| COMMISSARIAT A L' ENERGIE ATOMIQUE ET AUX ENERGIES ALTERNATIVES | 1             | 
| COMMUNE DE NICE                                                 | 1             | 
| COMMUNE DE TOULOUSE                                             | 1             | 
| CTRE HOSPITALIER UNIVERS PONTCHAILLOU                           | 1             | 
| DEPARTEMENT DE LA GIRONDE                                       | 1             | 
| DEPARTEMENT DE LA SEINE SAINT DENIS                             | 1             | 
| DEPARTEMENT DES BOUCHES DU RHONE                                | 1             | 
| DEPARTEMENT DES HAUTS-DE-SEINE                                  | 1             | 
| DEPARTEMENT DU VAL DE MARNE                                     | 1             | 
| DEPARTEMENT DU VAR                                              | 1             | 
| EURO DISNEY ASSOCIES SAS                                        | 1             | 
| EUROMETROPOLE DE STRASBOURG                                     | 1             | 
| LES HOPITAUX UNIVERSITAIRES DE STRASBOURG                       | 1             | 
| MANUF FRANC PNEUMATIQ MICHELIN                                  | 1             | 
| METROPOLE DE LYON                                               | 1             | 
| PREFECTURE DE POLICE DE PARIS                                   | 1             | 
| PSA AUTOMOBILES SA                                              | 3             | 
| REGION AUVERGNE-RHONE-ALPES                                     | 1             | 
| REGION HAUTS-DE-FRANCE                                          | 1             | 
| REGION ILE DE FRANCE                                            | 1             | 
| REGION PROVENCE-ALPES-COTE D'AZUR                               | 1             | 
| RENAULT SAS                                                     | 1             | 
| SAFRAN AIRCRAFT ENGINES                                         | 1             | 
| SOCIETE AIR FRANCE                                              | 1             | 
| SOCIETE GENERALE                                                | 1             | 

Ces entreprises sont a priori éligibles.

Nous pourrons, dans un deuxième temps, faire une estimation a minima de leurs effectifs théoriques en totalisant la somme des minimums de tranche de tous les établissements de même code siren.

### Deuxième approche : recherches d'établissements de plus de 10000 salariés hors de France
Le second tri vise à identifier les entreprises comportant au moins un établissement hors de France disposant d'un effectif supérieur à 10000 salariés (valeurs de tranche d'effectif 53).

Ce tri aboutit à un résultat nul.

### Troisième approche : regroupement d'établissment et somme par minima de tranches en France
Le troisième tri vise à identifier les entreprises totalisant plus de 5000 salariés par la somme du minimum de la tranche d'effectif de tous les établissements.

Ce tri permet l'identification de 136 unités légales, dont deux dépourvues de nom :
* 067800425 = ONET FRANCE ;
* 356000000 = LA POSTE.

La liste complète est fourni ci-dessous et stockée dans [U_groupees.csv]("./data_out/U_groupees.csv") :

|-----------|----------------|-------------|-----------------------------------------------------------------| 
| siren     | etablissements | effectifmin | denominationunitelegale                                         | 
| 067800425 | 6              | 18790       | NA                                                              | 
| 130005481 | 11             | 36997       | POLE EMPLOI                                                     | 
| 130015332 | 9              | 5458        | UNIVERSITE D'AIX MARSEILLE                                      | 
| 130015506 | 10             | 5177        | UNIVERSITE DE LORRAINE                                          | 
| 177501517 | 10             | 16893       | PREFECTURE DE POLICE DE PARIS                                   | 
| 180020026 | 9              | 5151        | CAISSE DES DEPOTS ET CONSIGNATIONS                              | 
| 180035024 | 9              | 6918        | CAISSE NATIONALE DE L'ASSURANCE MALADIE                         | 
| 180036048 | 10             | 6006        | INSTITUT NATIONAL DE LA SANTE ET DE LA RECHERCHE MEDICALE       | 
| 180070039 | 10             | 7262        | INSTITUT NATIONAL DE LA RECHERCHE AGRONOMIQUE                   | 
| 180089013 | 12             | 24303       | CTRE NAT DE LA RECHERCHE SCIENTIFIQUE                           | 
| 200023059 | 7              | 5516        | CENTRE HOSPITALIER REGIONAL ET UNIVERSITAIRE DE BREST           | 
| 200042166 | 7              | 8240        | CENTRE HOSPITALIER REGIONAL DE NANCY                            | 
| 200046977 | 2              | 5250        | METROPOLE DE LYON                                               | 
| 200053742 | 1              | 5000        | REGION HAUTS-DE-FRANCE                                          | 
| 200053759 | 5              | 5029        | REGION NOUVELLE-AQUITAINE                                       | 
| 200053767 | 1              | 5000        | REGION AUVERGNE-RHONE-ALPES                                     | 
| 200055358 | 1              | 5000        | CENTRE HOSPITALIER UNIVERSITAIRE DE POITIERS                    | 
| 210600888 | 7              | 7349        | COMMUNE DE NICE                                                 | 
| 211300553 | 10             | 11437       | COMMUNE DE MARSEILLE                                            | 
| 213105554 | 7              | 8303        | COMMUNE DE TOULOUSE                                             | 
| 216901231 | 10             | 8377        | COMMUNE DE LYON                                                 | 
| 217500016 | 12             | 47649       | COMMUNE DE PARIS                                                | 
| 221300015 | 10             | 6603        | DEPARTEMENT DES BOUCHES DU RHONE                                | 
| 223300013 | 5              | 5773        | DEPARTEMENT DE LA GIRONDE                                       | 
| 225900018 | 11             | 9191        | DEPARTEMENT DU NORD                                             | 
| 228300018 | 4              | 5271        | DEPARTEMENT DU VAR                                              | 
| 229200506 | 4              | 5027        | DEPARTEMENT DES HAUTS-DE-SEINE                                  | 
| 229300082 | 3              | 5270        | DEPARTEMENT DE LA SEINE SAINT DENIS                             | 
| 229400288 | 6              | 5383        | DEPARTEMENT DU VAL DE MARNE                                     | 
| 231300021 | 1              | 5000        | REGION PROVENCE-ALPES-COTE D'AZUR                               | 
| 237500079 | 3              | 6200        | REGION ILE DE FRANCE                                            | 
| 246700488 | 2              | 5200        | EUROMETROPOLE DE STRASBOURG                                     | 
| 260600705 | 3              | 5500        | CENTRE HOSPITALIER REGIONAL                                     | 
| 261300081 | 7              | 12117       | CENTRE HOSPITALIER REGIONAL DE MARSEILLE                        | 
| 261400931 | 2              | 5001        | CENTRE HOSPITALIER UNIVERSITAIRE DE CAEN NORMANDIE              | 
| 262100076 | 5              | 5307        | CENTRE HOSPITALIER UNIVERSITAIRE DE DIJON                       | 
| 262501760 | 6              | 5593        | CENTRE HOSPITALIER REGIONAL UNIVERSITAIRE                       | 
| 263000036 | 5              | 5950        | CENTRE HOSPITALIER UNIVERSITAIRE                                | 
| 263100125 | 9              | 10701       | CENTRE HOSPITALIER UNIVERSITAIRE DE TOULOUSE                    | 
| 263305823 | 7              | 10013       | CENTRE HOSPITALIER UNIVERSITAIRE DE BORDEAUX                    | 
| 263400160 | 9              | 9082        | CENTRE HOSPITALIER UNIVERSITAIRE DE MONTPELLIER                 | 
| 263500076 | 6              | 6900        | CTRE HOSPITALIER UNIVERS PONTCHAILLOU                           | 
| 263700189 | 7              | 5248        | CENTRE HOSPITALIER REGIONAL UNIVERSITAIRE DE TOURS              | 
| 263800302 | 4              | 5750        | CENTRE HOSPITALIER UNIVERSITAIRE GRENOBLE ALPES                 | 
| 264400136 | 5              | 8301        | CHU NANTES                                                      | 
| 264900036 | 5              | 5380        | CENTRE HOSPITALIER UNIVERSITAIRE D'ANGERS                       | 
| 265906719 | 12             | 12115       | CENTRE HOSPITALIER UNIVERSITAIRE DE LILLE                       | 
| 266307461 | 9              | 5009        | CENTRE HOSPITALIER UNIVERSITAIRE                                | 
| 266700574 | 9              | 8410        | LES HOPITAUX UNIVERSITAIRES DE STRASBOURG                       | 
| 266900273 | 8              | 13520       | HOSPICES CIVILS DE LYON                                         | 
| 267500049 | 10             | 5434        | CENTRE D'ACTION SOCIALE DE LA VILLE DE PARIS                    | 
| 267500452 | 9              | 60206       | ASSISTANCE PUBLIQUE HOPITAUX DE PARIS                           | 
| 267601680 | 8              | 7336        | CENTRE HOSPITALIER UNIVERSITAIRE ROUEN                          | 
| 268000148 | 6              | 6309        | CENTRE HOSPITALIER UNIVERSITAIRE                                | 
| 303409593 | 8              | 11821       | ELIOR SERVICES PROPRETE ET SANTE                                | 
| 304497852 | 9              | 8735        | SECURITAS FRANCE SARL                                           | 
| 312212301 | 9              | 5240        | RENAULT RETAIL GROUP                                            | 
| 315549352 | 7              | 6429        | ADREXO                                                          | 
| 326820065 | 9              | 7980        | SOPRA STERIA GROUP                                              | 
| 331648014 | 5              | 5384        | MEDIAPOST                                                       | 
| 341174118 | 6              | 5639        | MEDICA FRANCE                                                   | 
| 343262622 | 8              | 21834       | LIDL                                                            | 
| 348607417 | 5              | 5353        | ALTEN                                                           | 
| 351745724 | 3              | 6200        | MEUBLES IKEA FRANCE                                             | 
| 352383715 | 2              | 5250        | AIRBUS HELICOPTERS                                              | 
| 356000000 | 12             | 145682      | NA                                                              | 
| 380129866 | 12             | 66880       | ORANGE                                                          | 
| 383474814 | 4              | 5550        | AIRBUS                                                          | 
| 384560942 | 9              | 15293       | LEROY MERLIN FRANCE                                             | 
| 389191982 | 5              | 6250        | ALSTOM TRANSPORT SA                                             | 
| 397471822 | 1              | 10000       | EURO DISNEY ASSOCIES SAS                                        | 
| 399315613 | 7              | 6703        | METRO FRANCE                                                    | 
| 401251566 | 6              | 7506        | ORPEA                                                           | 
| 410034607 | 9              | 5027        | SUEZ EAU FRANCE                                                 | 
| 410409015 | 7              | 8288        | AUCHAN SUPERMARCHE                                              | 
| 410409460 | 9              | 41931       | AUCHAN HYPERMARCHE                                              | 
| 412280737 | 11             | 42831       | SNCF RESEAU                                                     | 
| 413901760 | 7              | 5475        | ELIOR ENTREPRISES                                               | 
| 414815217 | 8              | 10120       | SAFRAN AIRCRAFT ENGINES                                         | 
| 414819409 | 8              | 5864        | CONFORAMA FRANCE                                                | 
| 420495178 | 13             | 30126       | SOCIETE AIR FRANCE                                              | 
| 420916918 | 3              | 14020       | AIRBUS OPERATIONS                                               | 
| 428240287 | 6              | 5103        | CARREFOUR SUPPLY CHAIN                                          | 
| 428268023 | 10             | 19574       | DISTRIBUTION CASINO FRANCE                                      | 
| 428685358 | 7              | 6743        | SAMSIC II                                                       | 
| 428764500 | 6              | 5770        | AREVA NP                                                        | 
| 428822852 | 9              | 5932        | ETABLISSEMENT FRANCAIS DU SANG                                  | 
| 432766947 | 10             | 6178        | FRANCE TELEVISIONS                                              | 
| 440283752 | 6              | 18590       | CSF                                                             | 
| 441133808 | 6              | 6260        | NAVAL GROUP                                                     | 
| 444608442 | 10             | 29579       | ENEDIS                                                          | 
| 444619258 | 10             | 6963        | RTE RESEAU DE TRANSPORT D ELECTRICITE                           | 
| 444718563 | 4              | 5450        | ARCELORMITTAL ATLANTIQUE ET LORRAINE                            | 
| 444786511 | 9              | 5739        | GRDF                                                            | 
| 451321335 | 8              | 44457       | CARREFOUR HYPERMARCHES                                          | 
| 451647903 | 5              | 5756        | BRICO DEPOT                                                     | 
| 451678973 | 8              | 10163       | CASTORAMA FRANCE                                                | 
| 456500537 | 9              | 6707        | DALKIA                                                          | 
| 479766842 | 9              | 7013        | CAPGEMINI TECHNOLOGY SERVICES                                   | 
| 500569405 | 8              | 10268       | DECATHLON FRANCE                                                | 
| 514080837 | 8              | 6008        | ITM LOGISTIQUE ALIMENTAIRE INTERNATIONAL                        | 
| 542016951 | 9              | 10464       | ISS PROPRETE                                                    | 
| 542065479 | 10             | 40516       | PSA AUTOMOBILES SA                                              | 
| 552046955 | 8              | 7001        | ENGIE ENERGIE SERVICES                                          | 
| 552049447 | 11             | 66987       | SNCF MOBILITES                                                  | 
| 552081317 | 12             | 54569       | ELECTRICITE DE FRANCE                                           | 
| 552083297 | 7              | 11284       | MONOPRIX EXPLOIT PAR ABREVIATION MPX                            | 
| 552118465 | 9              | 5037        | CIE IBM FRANCE                                                  | 
| 552120222 | 13             | 30253       | SOCIETE GENERALE                                                | 
| 572025526 | 9              | 5391        | VEOLIA EAU - COMPAGNIE GENERALE DES EAUX                        | 
| 572104891 | 12             | 8289        | BANQUE DE FRANCE                                                | 
| 632012100 | 10             | 5747        | L'OREAL                                                         | 
| 632041042 | 9              | 8616        | COMPASS GROUP FRANCE                                            | 
| 662025196 | 9              | 7187        | ELRES                                                           | 
| 662042449 | 11             | 30910       | BNP PARIBAS                                                     | 
| 662043116 | 9              | 5672        | OFFICE NATIONAL DES FORETS                                      | 
| 702012956 | 10             | 6453        | ALTRAN TECHNOLOGIES                                             | 
| 702021114 | 7              | 8632        | DERICHEBOURG PROPRETE                                           | 
| 702042755 | 6              | 6170        | CGI FRANCE                                                      | 
| 712042456 | 5              | 5350        | DASSAULT AVIATION                                               | 
| 722057460 | 11             | 8728        | AXA FRANCE IARD                                                 | 
| 775663438 | 11             | 34608       | REGIE AUTONOME DES TRANSPORTS PARISIENS                         | 
| 775670284 | 10             | 5732        | HSBC FRANCE                                                     | 
| 775672272 | 10             | 12269       | CROIX ROUGE FRANCAISE                                           | 
| 775685019 | 9              | 14856       | COMMISSARIAT A L' ENERGIE ATOMIQUE ET AUX ENERGIES ALTERNATIVES | 
| 775688732 | 8              | 10683       | APF FRANCE HANDICAP                                             | 
| 775709702 | 9              | 6177        | MUTUELLE ASSURANCE INSTITUTEUR FRANCE                           | 
| 775726417 | 9              | 5347        | KPMG                                                            | 
| 780129987 | 8              | 18760       | RENAULT SAS                                                     | 
| 781452511 | 10             | 7040        | MACIF                                                           | 
| 786920306 | 9              | 14441       | CORA                                                            | 
| 801947052 | 10             | 5911        | GIE AG2R REUNICA                                                | 
| 808332670 | 10             | 8167        | SNCF                                                            | 
| 855200507 | 10             | 21003       | MANUF FRANC PNEUMATIQ MICHELIN                                  | 
| 954506077 | 6              | 5323        | RENAULT TRUCKS                                                  | 
| 954509741 | 10             | 14262       | CREDIT LYONNAIS                                                 | 



### Quatrième approche : groupement des établissements à l'étranger