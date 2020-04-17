# ##################################################################################
# Modifier la projection d'une carte
#                           Exemple avec la France et l'australie
# ##################################################################################
# Objectif : 
# ----------------------------------------------------------------------------------
# Montrer l'importance d'une definition correcte de la projection 
# ----------------------------------------------------------------------------------
# Choix des projections comparees : 
#           -> EPSG 3035 (referentiel francais) 
#           -> WGS84 (coordonnees GPS)
# ----------------------------------------------------------------------------------
# Choix des pays : 
#           -> France (peu impactee car referentiel francais) 
#           -> Australie (tres impactee) 
# ##################################################################################


# ##################################################################################
#                               Source des donnees
# ##################################################################################
# Les donnees utilisees ont ete telechargees depuis le site http://www.gadm.org/country
# Enregistrer ces donnees dans un repertoire, recuperer le chemin pour renseigner la 
# variable "root" ci dessous
# ##################################################################################

# Liste des systemes de coordonnees sous PROJ.4
prjs <- make_EPSG()


# Chemin d'acces au repertoire ou sont stockees les donnees
root = "C:/Users/Admin/Desktop/Sarah_DAYMIER/Livrable_BNP/02_BDD"

# Affichage du contenu du repertoire : 
dir(root)

# Chargement des packages : 
library(rgdal)
library(sp)

# ##################################################################################
#                                     Cas France
# ##################################################################################

# >>> Importation d'une couche vectorielle "France"
# ----------------------------------------------------------------------------------
dir(paste0(root,"/Data_France/"))
fr1 <- readOGR(dsn = paste0(root,"/Data_France"), layer = "FRA_adm1", verbose = F)

# >>> Affichage du referentiel
# ----------------------------------------------------------------------------------
fr1@proj4string

# Resultat : 
# CRS arguments: +proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0 

# >>> Affichage avec WGS 84
# ----------------------------------------------------------------------------------
plot(fr1, col = "gray", main = paste0("Metropole Francaise - WGS84"))

# >>> Modification du referentiel : passage de WGS84 a EPSG3035
# ----------------------------------------------------------------------------------
fr1p <- spTransform(x = fr1, CRSobj = CRS("+init=epsg:3035"))

# Verification
fr1p@proj4string

# Resultat : 
# CRS arguments:  
# +init=epsg:3035 +proj=laea +lat_0=52 +lon_0=10 +x_0=4321000 +y_0=3210000 +ellps=GRS80
# +towgs84=0,0,0,0,0,0,0 +units=m +no_defs

# >>> Affichage avec WGS 84
# ----------------------------------------------------------------------------------
plot(fr1p, col = "gray", main = "Metropole Francaise - EPSG 3035")


# ##################################################################################
#                                     Cas Australie
# ##################################################################################

# >>> Importation d'une couche vectorielle
# ----------------------------------------------------------------------------------

aus1 <- readOGR(dsn = paste0(root,"/Data_Aust"), layer = "AUS_adm1", verbose = F)

# >>> Affichage du referentiel
aus1@proj4string

# Resultat : 
# CRS arguments: +proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0 

# >>> Affichage avec WGS 84
# ----------------------------------------------------------------------------------
plot(aus1, col = "gray", main = paste0("Australie - WGS84"))

# >>> Modification du referentiel : passage de WGS84 a EPSG3035
# ----------------------------------------------------------------------------------
aus1p <- spTransform(x = aus1, CRSobj = CRS("+init=epsg:3035"))

# Verification
fr1p@proj4string

# Resultat : 
# CRS arguments:  
# +init=epsg:3035 +proj=laea +lat_0=52 +lon_0=10 +x_0=4321000 +y_0=3210000 +ellps=GRS80
# +towgs84=0,0,0,0,0,0,0 +units=m +no_defs

# >>> Affichage avec WGS 84
# ----------------------------------------------------------------------------------
plot(aus1p, col = "gray", main = "Australie - EPSG 3035")

