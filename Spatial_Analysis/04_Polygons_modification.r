# ##################################################################################
# Modifier l'ID des polygones contenus dans un SpatialPolygonsDataFrame
#                           Exemple avec les Open Data Pologne
# ##################################################################################

# ----------------------------------------------------------------------------------
# Chargement des packages : 
# ----------------------------------------------------------------------------------
library(rgdal)

# ##################################################################################
# Chargement des donnees spatiales : 
# ##################################################################################
# Source de donnees : http://codgik.gov.pl/index.php/darmowe-dane/prg.html 
# Recuperer les fichiers shapefile, qui se trouvent dans un format zip
# Dezipper le dossier et sauvegarder tous les elements dans un repertoire
# ##################################################################################

# >>> Importation d'une couche vectorielle "Pologne"
# ----------------------------------------------------------------------------------
root = "C:/Users/Admin/Desktop/Sarah_DAYMIER/Livrable_BNP/02_BDD/Data_Poland"
# Definition du repertoire ou sont stockees les cartes
root_carte = paste0(root,"/PRG_jednostki_administracyjne_v13"); 

# Importation de la carte au niveau "wojewodztwa"
wojewodztwa <- readOGR(dsn = root_carte, layer = "wojewodztwa", 
                       verbose = F,stringsAsFactors=FALSE)
# Modification du CRS
wojewodztwaWGS <- spTransform(wojewodztwa, CRS("+init=epsg:4326"))



# >>> Creation d'une colonne POLYID
# ----------------------------------------------------------------------------------

# The ID slot is what ties the geometries and the attributes.
all(lapply(wojewodztwaWGS@polygons, slot, "ID") == wojewodztwaWGS@data$jpt_kod_je)           # False
all(lapply(wojewodztwaWGS@polygons, slot, "ID") == rownames(wojewodztwaWGS@data$jpt_kod_je)) # TRUE

# Creation d'une colonne ID_plot qui reprend le nom des lignes
# (methode plus facile que de modifier l'ID des polygones)

wojewodztwaWGS@data$POLYID <- rownames(wojewodztwaWGS@data)

