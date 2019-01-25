En cours.

## Sources

Primaires :
* Sirene, stock établissements au 01/2019 : https://www.data.gouv.fr/fr/datasets/r/d9c12e7e-6a9d-4564-a846-86b8b563a477 (as "./data/StockEtablissement_utf8.csv") ;

Secondaires :
* BDD des tranches d'effectifs sur la base de la doc (as "./data/effectifs.csv")

## Etat des recherches

### Nettoyage
Constitution de deux BDDs légères : une BDD effectifs et une BDD noms sur la base d'une version filtrée (exclusion des établissements fermés et des effectifs nuls ou sans effectifs).

### Calculs

#### Première approche : recherches d'établissements de plus de 5000 salariés en France
Le premier tri vise à identifier les entreprises comportant au moins un établissement basé en France disposant d'un effectif supérieur à 5000 salariés (valeurs de tranche d'effectif 52 ou 53).

Ce tri permet l'identification de 45 unités légales, dont deux (PSA Automobiles SA et APHP) disposant de trois établissements à plus de 5000 salariés.

La liste complète est fourni ci-dessous et stockée dans "./data_out/Et_sup_5000.csv" :


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

#### Deuxième approche : recherches d'établissements de plus de 10000 salariés hors de France
Le second tri vise à identifier les entreprises comportant au moins un établissement hors de France disposant d'un effectif supérieur à 10000 salariés (valeurs de tranche d'effectif 53).

Ce tri aboutit à un résultat nul.

#### Troisième approche : regroupement d'établissment et somme par minima de tranches en France
Le troisième tri vise à identifier les entreprises totalisant plus de 5000 salariés par la somme du minimum de la tranche d'effectif de tous les établissements.
