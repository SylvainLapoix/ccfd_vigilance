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

Ce tri permet l'identification de 103 unités légales, dont deux dépourvues de nom :
* 067800425 = ONET FRANCE ;
* 356000000 = LA POSTE.

La liste complète est fourni ci-dessous et stockée dans [U_groupees.csv]("./data_out/U_groupees.csv") :

| siren     | etablissements | effectifmin | categorieentreprise | denominationunitelegale                                         | denominationusuelle1unitelegale                                          | 
|-----------|----------------|-------------|---------------------|-----------------------------------------------------------------|--------------------------------------------------------------------------| 
| 067800425 | 6              | 18790       | NA                  | NA                                                              | NA                                                                       | 
| 130005481 | 11             | 36997       | GE                  | POLE EMPLOI                                                     | NA                                                                       | 
| 130015332 | 9              | 5458        | GE                  | UNIVERSITE D'AIX MARSEILLE                                      | NA                                                                       | 
| 130015506 | 10             | 5177        | GE                  | UNIVERSITE DE LORRAINE                                          | NA                                                                       | 
| 177501517 | 9              | 6893        | GE                  | PREFECTURE DE POLICE DE PARIS                                   | NA                                                                       | 
| 180020026 | 9              | 5151        | GE                  | CAISSE DES DEPOTS ET CONSIGNATIONS                              | NA                                                                       | 
| 180035024 | 9              | 6918        | GE                  | CAISSE NATIONALE DE L'ASSURANCE MALADIE                         | NA                                                                       | 
| 180036048 | 10             | 6006        | GE                  | INSTITUT NATIONAL DE LA SANTE ET DE LA RECHERCHE MEDICALE       | NA                                                                       | 
| 180070039 | 10             | 7262        | GE                  | INSTITUT NATIONAL DE LA RECHERCHE AGRONOMIQUE                   | NA                                                                       | 
| 180089013 | 12             | 24303       | GE                  | CTRE NAT DE LA RECHERCHE SCIENTIFIQUE                           | NA                                                                       | 
| 200023059 | 7              | 5516        | GE                  | CENTRE HOSPITALIER REGIONAL ET UNIVERSITAIRE DE BREST           | NA                                                                       | 
| 200053759 | 5              | 5029        | NA                  | REGION NOUVELLE-AQUITAINE                                       | NA                                                                       | 
| 211300553 | 10             | 11437       | GE                  | COMMUNE DE MARSEILLE                                            | NA                                                                       | 
| 216901231 | 10             | 8377        | GE                  | COMMUNE DE LYON                                                 | NA                                                                       | 
| 217500016 | 12             | 47649       | GE                  | COMMUNE DE PARIS                                                | NA                                                                       | 
| 225900018 | 11             | 9191        | GE                  | DEPARTEMENT DU NORD                                             | NA                                                                       | 
| 260600705 | 3              | 5500        | GE                  | CENTRE HOSPITALIER REGIONAL                                     | NA                                                                       | 
| 261300081 | 6              | 7117        | GE                  | CENTRE HOSPITALIER REGIONAL DE MARSEILLE                        | NA                                                                       | 
| 263100125 | 8              | 5701        | GE                  | CENTRE HOSPITALIER UNIVERSITAIRE DE TOULOUSE                    | NA                                                                       | 
| 263305823 | 6              | 5013        | GE                  | CENTRE HOSPITALIER UNIVERSITAIRE DE BORDEAUX                    | NA                                                                       | 
| 263400160 | 9              | 9082        | GE                  | CENTRE HOSPITALIER UNIVERSITAIRE DE MONTPELLIER                 | NA                                                                       | 
| 263700189 | 7              | 5248        | GE                  | CENTRE HOSPITALIER REGIONAL UNIVERSITAIRE DE TOURS              | NA                                                                       | 
| 265906719 | 11             | 7115        | GE                  | CENTRE HOSPITALIER UNIVERSITAIRE DE LILLE                       | NA                                                                       | 
| 266307461 | 9              | 5009        | GE                  | CENTRE HOSPITALIER UNIVERSITAIRE                                | NA                                                                       | 
| 266900273 | 8              | 13520       | GE                  | HOSPICES CIVILS DE LYON                                         | NA                                                                       | 
| 267500049 | 10             | 5434        | GE                  | CENTRE D'ACTION SOCIALE DE LA VILLE DE PARIS                    | NA                                                                       | 
| 267500452 | 8              | 45206       | GE                  | ASSISTANCE PUBLIQUE HOPITAUX DE PARIS                           | NA                                                                       | 
| 303409593 | 8              | 11821       | GE                  | ELIOR SERVICES PROPRETE ET SANTE                                | NA                                                                       | 
| 304497852 | 9              | 8735        | GE                  | SECURITAS FRANCE SARL                                           | NA                                                                       | 
| 312212301 | 9              | 5240        | GE                  | RENAULT RETAIL GROUP                                            | NA                                                                       | 
| 315549352 | 7              | 6429        | GE                  | ADREXO                                                          | PROSPECTUS MAILING ADRESSE BAL GEOMARKET                                 | 
| 326820065 | 9              | 7980        | GE                  | SOPRA STERIA GROUP                                              | NA                                                                       | 
| 331648014 | 5              | 5384        | GE                  | MEDIAPOST                                                       | NA                                                                       | 
| 341174118 | 6              | 5639        | GE                  | MEDICA FRANCE                                                   | NA                                                                       | 
| 343262622 | 8              | 21834       | GE                  | LIDL                                                            | SNC LIDL                                                                 | 
| 351745724 | 3              | 6200        | GE                  | MEUBLES IKEA FRANCE                                             | IKEA                                                                     | 
| 356000000 | 12             | 145682      | NA                  | NA                                                              | NA                                                                       | 
| 380129866 | 12             | 66880       | GE                  | ORANGE                                                          | NA                                                                       | 
| 384560942 | 9              | 15293       | GE                  | LEROY MERLIN FRANCE                                             | NA                                                                       | 
| 389191982 | 5              | 6250        | GE                  | ALSTOM TRANSPORT SA                                             | NA                                                                       | 
| 399315613 | 7              | 6703        | GE                  | METRO FRANCE                                                    | METRO ON LINE-MAKRO ON LINE METRO....                                    | 
| 401251566 | 6              | 7506        | GE                  | ORPEA                                                           | NA                                                                       | 
| 410034607 | 9              | 5027        | GE                  | SUEZ EAU FRANCE                                                 | NA                                                                       | 
| 410409015 | 7              | 8288        | GE                  | AUCHAN SUPERMARCHE                                              | ATAC                                                                     | 
| 410409460 | 9              | 41931       | GE                  | AUCHAN HYPERMARCHE                                              | NA                                                                       | 
| 412280737 | 11             | 42831       | GE                  | SNCF RESEAU                                                     | NA                                                                       | 
| 413901760 | 7              | 5475        | GE                  | ELIOR ENTREPRISES                                               | NA                                                                       | 
| 414815217 | 7              | 5120        | GE                  | SAFRAN AIRCRAFT ENGINES                                         | NA                                                                       | 
| 414819409 | 8              | 5864        | GE                  | CONFORAMA FRANCE                                                | NA                                                                       | 
| 420495178 | 12             | 20126       | GE                  | SOCIETE AIR FRANCE                                              | SKYTEAM                                                                  | 
| 428240287 | 6              | 5103        | GE                  | CARREFOUR SUPPLY CHAIN                                          | NA                                                                       | 
| 428268023 | 10             | 19574       | GE                  | DISTRIBUTION CASINO FRANCE                                      | NA                                                                       | 
| 428685358 | 7              | 6743        | GE                  | SAMSIC II                                                       | SAMSIC PROPRETE                                                          | 
| 428764500 | 6              | 5770        | GE                  | AREVA NP                                                        | NA                                                                       | 
| 428822852 | 9              | 5932        | GE                  | ETABLISSEMENT FRANCAIS DU SANG                                  | NA                                                                       | 
| 432766947 | 10             | 6178        | GE                  | FRANCE TELEVISIONS                                              | FRANCE TELEVISIONS                                                       | 
| 440283752 | 6              | 18590       | GE                  | CSF                                                             | NA                                                                       | 
| 441133808 | 6              | 6260        | GE                  | NAVAL GROUP                                                     | NA                                                                       | 
| 444608442 | 10             | 29579       | GE                  | ENEDIS                                                          | NA                                                                       | 
| 444619258 | 10             | 6963        | GE                  | RTE RESEAU DE TRANSPORT D ELECTRICITE                           | NA                                                                       | 
| 444718563 | 4              | 5450        | GE                  | ARCELORMITTAL ATLANTIQUE ET LORRAINE                            | NA                                                                       | 
| 444786511 | 9              | 5739        | GE                  | GRDF                                                            | NA                                                                       | 
| 451321335 | 8              | 44457       | GE                  | CARREFOUR HYPERMARCHES                                          | NA                                                                       | 
| 451647903 | 5              | 5756        | GE                  | BRICO DEPOT                                                     | NA                                                                       | 
| 451678973 | 8              | 10163       | GE                  | CASTORAMA FRANCE                                                | NA                                                                       | 
| 456500537 | 9              | 6707        | GE                  | DALKIA                                                          | NA                                                                       | 
| 479766842 | 9              | 7013        | GE                  | CAPGEMINI TECHNOLOGY SERVICES                                   | NA                                                                       | 
| 500569405 | 8              | 10268       | GE                  | DECATHLON FRANCE                                                | NA                                                                       | 
| 514080837 | 8              | 6008        | GE                  | ITM LOGISTIQUE ALIMENTAIRE INTERNATIONAL                        | NA                                                                       | 
| 542016951 | 9              | 10464       | GE                  | ISS PROPRETE                                                    | NA                                                                       | 
| 542065479 | 9              | 25516       | GE                  | PSA AUTOMOBILES SA                                              | NA                                                                       | 
| 552046955 | 8              | 7001        | GE                  | ENGIE ENERGIE SERVICES                                          | NA                                                                       | 
| 552049447 | 11             | 66987       | GE                  | SNCF MOBILITES                                                  | NA                                                                       | 
| 552081317 | 12             | 54569       | GE                  | ELECTRICITE DE FRANCE                                           | NA                                                                       | 
| 552083297 | 7              | 11284       | GE                  | MONOPRIX EXPLOIT PAR ABREVIATION MPX                            | NA                                                                       | 
| 552118465 | 9              | 5037        | GE                  | CIE IBM FRANCE                                                  | NA                                                                       | 
| 552120222 | 12             | 25253       | GE                  | SOCIETE GENERALE                                                | SOCIETE GENERALE                                                         | 
| 572025526 | 9              | 5391        | GE                  | VEOLIA EAU - COMPAGNIE GENERALE DES EAUX                        | NA                                                                       | 
| 572104891 | 12             | 8289        | GE                  | BANQUE DE FRANCE                                                | NA                                                                       | 
| 632012100 | 10             | 5747        | GE                  | L'OREAL                                                         | NA                                                                       | 
| 632041042 | 9              | 8616        | GE                  | COMPASS GROUP FRANCE                                            | SCOLAREST MEDIREST EUREST                                                | 
| 662025196 | 9              | 7187        | GE                  | ELRES                                                           | NA                                                                       | 
| 662042449 | 11             | 30910       | GE                  | BNP PARIBAS                                                     | NA                                                                       | 
| 662043116 | 9              | 5672        | NA                  | OFFICE NATIONAL DES FORETS                                      | NA                                                                       | 
| 702012956 | 10             | 6453        | GE                  | ALTRAN TECHNOLOGIES                                             | NA                                                                       | 
| 702021114 | 7              | 8632        | GE                  | DERICHEBOURG PROPRETE                                           | NA                                                                       | 
| 702042755 | 6              | 6170        | GE                  | CGI FRANCE                                                      | NA                                                                       | 
| 712042456 | 5              | 5350        | GE                  | DASSAULT AVIATION                                               | NA                                                                       | 
| 775663438 | 11             | 34608       | GE                  | REGIE AUTONOME DES TRANSPORTS PARISIENS                         | NA                                                                       | 
| 775670284 | 10             | 5732        | GE                  | HSBC FRANCE                                                     | HSBC                                                                     | 
| 775672272 | 10             | 12269       | GE                  | CROIX ROUGE FRANCAISE                                           | NA                                                                       | 
| 775685019 | 8              | 9856        | GE                  | COMMISSARIAT A L' ENERGIE ATOMIQUE ET AUX ENERGIES ALTERNATIVES | CEA                                                                      | 
| 775688732 | 8              | 10683       | GE                  | APF FRANCE HANDICAP                                             | NA                                                                       | 
| 775709702 | 9              | 6177        | GE                  | MUTUELLE ASSURANCE INSTITUTEUR FRANCE                           | NA                                                                       | 
| 775726417 | 9              | 5347        | GE                  | KPMG                                                            | KPMG SA                                                                  | 
| 780129987 | 7              | 13760       | GE                  | RENAULT SAS                                                     | NA                                                                       | 
| 781452511 | 10             | 7040        | GE                  | MACIF                                                           | NA                                                                       | 
| 786920306 | 9              | 14441       | GE                  | CORA                                                            | CORA                                                                     | 
| 801947052 | 10             | 5911        | GE                  | GIE AG2R REUNICA                                                | NA                                                                       | 
| 808332670 | 10             | 8167        | GE                  | SNCF                                                            | NA                                                                       | 
| 855200507 | 9              | 11003       | GE                  | MANUF FRANC PNEUMATIQ MICHELIN                                  | NA                                                                       | 
| 954506077 | 6              | 5323        | GE                  | RENAULT TRUCKS                                                  | "RENAULT TRUCKS, RENAULT V.I., TRUCKONE, VOLVO GROUP TRUCKS SALES & MAR" | 
| 954509741 | 10             | 14262       | GE                  | CREDIT LYONNAIS                                                 | LCL - LE CREDIT LYONNAIS                                                 | 

- manque quelques opérations pour réconcilier les deux bases et extraire les doublons -

### Quatrième approche : groupement des établissements à l'étranger