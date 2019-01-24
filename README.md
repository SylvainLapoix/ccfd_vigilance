Repo du projet CCFD - Devoir de vigilance

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

*Première approche : quanti strict par siren*
Premier groupe des entreprises avec des effectifs en France > 5000 :
* 50 matchs ;
* seulement 23 avec "enseigne1etablissement" renseigné ;
* seulement 1 avec "denominationusuelleetablissement" renseigné (déjà incluse dans les 23 précédentes).

Deux sociétés privées apparaissent dans ce groupement :
* **DISNEYLAND PARIS-DISNEY VILLAGE-WALT DISNEY STUDIO** ;
* **ALTEN JEAN JAURES**.

