# ##################################################################################
# Ajouter des donnees attributaires sur un fond de carte
#                           Exemple avec les Open Data Pologne
# ##################################################################################
# Objectif : 
# ----------------------------------------------------------------------------------
# 
# ##################################################################################

# ----------------------------------------------------------------------------------
# Chargement des packages : 
# ----------------------------------------------------------------------------------
library(rgdal)
library(reshape)
library(reshape2)
library(data.table)

# ##################################################################################
# Chargement des donnees attributaire: 
# ##################################################################################
root = "C:/Users/Admin/Desktop/Sarah_DAYMIER/Livrable_BNP/02_BDD/Data_Poland"
nom_file <- dir(paste0(root,"/Open_Data"))

# Affichage : [1] "Higher_educ_female.csv" "Higher_educ_male.csv"

# ----------------------------------------------------------------------------------
# "Trick" pour importer et retraiter rapidemment les donnees
# ----------------------------------------------------------------------------------
res = data.frame()

for (tmp in nom_file){
  
  # Affichage du nom du fichier en cours d'importation et de preparation
  print(tmp)
  
  # Recuperation du "genre" (car affiche dans le nom du fichier)
  gender_a = strsplit(tmp, "_")[[1]][3]
  
  # Importation donnees
  tab <- read.csv(file = paste(root, "/Open_Data/",tmp, sep = ""),header =TRUE,sep=",")

  # Pivot table comme dans Excel avec la fonction cast
  tab <- cast(tab, NAZWA_TERYT1 ~ KOD_ROKU1)
  
  # On supprime les donnees niveau national
  tab <- tab[which(tab$NAZWA_TERYT1 != "POLSKA"),] 
  tab$gender <- gender_a
  
  # Enregistrement dans une base globale
  res = rbind(res, tab)
  
  # Nettoyage de l'environnement
  rm(tab) 
}

# Visualisation des bases de données
View(res)

# ##################################################################################
# Chargement des donnees spatiales : 
# ##################################################################################
# Source de donnees : http://codgik.gov.pl/index.php/darmowe-dane/prg.html 
# Recuperer les fichiers shapefile, qui se trouvent dans un format zip
# Dezipper le dossier et sauvegarder tous les elements dans un repertoire
# ##################################################################################

# >>> Importation d'une couche vectorielle "Pologne"
# ----------------------------------------------------------------------------------

# Definition du repertoire ou sont stockees les cartes
root_carte = paste0(root,"/PRG_jednostki_administracyjne_v13"); 

# Importation de la carte au niveau "wojewodztwa"
wojewodztwa <- readOGR(dsn = root_carte, layer = "wojewodztwa", 
                       verbose = F,stringsAsFactors=FALSE)

slotNames(wojewodztwa)   # Affichage des differents slot contenu dans l'objet spatial
str(wojewodztwa)         # Affichage de la structure de l'objet spatial

# Analyse du contenu du slot "polygons"
slotNames(wojewodztwa@polygons[[1]])
class(wojewodztwa@polygons[[1]]@Polygons)  # list
class(wojewodztwa@polygons[[1]]@plotOrder) # integer
class(wojewodztwa@polygons[[1]]@labpt)     # numeric
class(wojewodztwa@polygons[[1]]@ID)        # character
class(wojewodztwa@polygons[[1]]@area)      # numeric

str(wojewodztwa@polygons[[1]]@Polygons)
class?Polygons

# Quel est le CRS?
wojewodztwa@proj4string

# Resultat : 
# CRS arguments:
# +proj=tmerc +lat_0=0 +lon_0=18.99999999999998 +k=0.9993 +x_0=500000 +y_0=-5300000
# +ellps=GRS80 +towgs84=0,0,0 +units=m +no_defs 

# Modification du CRS
# ----------------------------------------------------------------------------------
wojewodztwaWGS <- spTransform(wojewodztwa, CRS("+init=epsg:4326"))

# >>> Visualisation des donnees attributaires presentes dans le fichier spatial
# ----------------------------------------------------------------------------------
View(wojewodztwaWGS@data)

# ----------------------------------------------------------------------------------
# Remarque :
# Beaucoup de ces donnees ne nous sont pas utiles pour la suite. On peut par exemple 
# ne conserver que les variables suivantes : 
#     -> jpt_sjr_ko
#     -> jpt_kod_je
#     -> jpt_nazwa_
# ----------------------------------------------------------------------------------

# Affichage de la dimension initiale : 
dim(wojewodztwaWGS@data) # 16 observations et 29 variables 

# Identification des variables a conserver
var_keep <- c("jpt_sjr_ko", "jpt_kod_je", "jpt_nazwa_")    

# Reduction du dataframe affilie au l'objet  spatial
wojewodztwaWGS@data <- wojewodztwaWGS@data[,var_keep]

# Nouvelle dimension de la base de donnees :
dim(wojewodztwaWGS@data) # 16 observations et 3 variables

# ----------------------------------------------------------------------------------
# Code des Voivodships
# ----------------------------------------------------------------------------------
files_admin_div = paste0(root, "/Code_correspondance")

# Importer les donnees
code_voivod <- read.csv(file = paste0(files_admin_div, "/code_voivodeship.csv", sep = ""),
                        header =TRUE,
                        sep=";")

# Supprimer ligne vide
code_voivod <- subset(code_voivod, Polish.name != "") 

# Conversion en upper case
code_voivod$Polish.name <- toupper(code_voivod$Polish.name) 

# Affichage
View(code_voivod)


# ##################################################################################
# Ajouter des donnees attributaires
# ##################################################################################
# Comment ca se deroule?
# ----------------------------------------------------------------------------------
# 1. On "sort" les @data de l'objet spatial
# 2. On effectue les traitements souhaites (ici, une jointure)
# 3. On reintegre le nouveau dataframe dans l'objet  spatial
# ##################################################################################
# Remarque : 
# ----------------------------------------------------------------------------------
# Dans l'exemple qui nous interesse, on ne dispose pas de code particulier permettant
# de faire la jointure entre le dataframe importe, et celui relatif a l'objet spatial
# on doit donc faire appel a une table tierce pour pouvoir effectuer la jointre
# cela ne change rien au raisonnement global
# ##################################################################################
# 3 etapes dans notre exemple : 
#     -> Ajout des code_voivod (cle de jointure)
#               -> dans les donnes Open data                    (m1a)
#               -> dans les donnes de l'objet spatial           (m1b)
#     -> Jointure entre m1a et m1b                              (m2)
#     -> Reinjecter le nouveau dataframe dans l'objet spatial
# ##################################################################################

# >>> Creation d'une colonne POLYID dans le dataframe de l'objet spatial
# ----------------------------------------------------------------------------------

# The ID slot is what ties the geometries and the attributes.
all(lapply(wojewodztwaWGS@polygons, slot, "ID") == wojewodztwaWGS@data$jpt_kod_je)           # False
all(lapply(wojewodztwaWGS@polygons, slot, "ID") == rownames(wojewodztwaWGS@data$jpt_kod_je)) # TRUE

# Creation d'une colonne ID_plot qui reprend le nom des lignes
# (methode plus facile que de modifier l'ID des polygones)

wojewodztwaWGS@data$POLYID <- rownames(wojewodztwaWGS@data)
View(wojewodztwaWGS@data)

# >>> Ajout des code_voivod dans le dataframe des donnees Open Data
# ----------------------------------------------------------------------------------

# >>> Premiere methode avec la creation d'une table temporaire
m1a <- merge(res,                    # Correspond aux "x"
            code_voivod,             # Correspond aux "y"
            by.x = "NAZWA_TERYT1", 
            by.y = "Polish.name")


# >>> Ajout des code_voivod dans le dataframe des donnees spatiales
# ----------------------------------------------------------------------------------
m1b <- merge(wojewodztwaWGS@data,    # Correspond aux "x"
               code_voivod,          # Correspond aux "y"
               by.x = "jpt_kod_je", 
               by.y = "Teryt.")

# >>> Deuxieme methode avec l'ajout direct des donnees dans la table attributaire
library(dplyr)

# Rappel : les jointures ne peuvent s'effectuer que si les variables sont de même format
class(wojewodztwaWGS@data$jpt_kod_je) # Character
class(code_voivod$Teryt.)             # Factor

# Modification du format de la variable Teryt.
code_voivod$Teryt. <- as.character(code_voivod$Teryt.)

# On remplace le slot @data par un nouveau tableau de données, contenant les anciennes données + les nouvelles
wojewodztwaWGS@data <- left_join(wojewodztwaWGS@data, code_voivod, by = c("jpt_kod_je" = "Teryt."))


# >>> Fusionner la base Open Data  avec le dataframe spatial
# ----------------------------------------------------------------------------------
m2 <- merge(m1a,                     # Correspond aux "x" 
            m1b,                     # Correspond aux "y"
            by.x = "Teryt.", 
            by.y = "jpt_kod_je")

# Probleme ici : la cle n'est plus unique
View(m2)

# Filtre : on ne conserve que les femmes par exemple
m2_bis <- m2[which(m2$gender %like% "^female.*?"),]

# On réordonne les data en fonction du polyID
wojewodztwaWGS@data <- m2_bis[order(as.numeric(m2_bis$POLYID)),]

# Comme c'est le nom de la ligne qui fait  le lien avec l'ID des polygones, on renomme les lignes
rownames(wojewodztwaWGS@data) <- wojewodztwaWGS@data$POLYID

# Check : 
all(lapply(wojewodztwaWGS@polygons, slot, "ID") == rownames(wojewodztwaWGS@data)) # TRUE
# True

# Verification
dim(wojewodztwaWGS@data)   # [1] 16 26 
View(wojewodztwaWGS@data)

# ##################################################################################
# Nettoyage
# ##################################################################################
rm(m1a,m1b,m2,m2_bis,
   root,root_carte,files_admin_div,
   var_keep,tmp, nom_file,gender_a) 

# >>> On peut  exporter les resultats sous forme de Shapefile (voir note 04e)
