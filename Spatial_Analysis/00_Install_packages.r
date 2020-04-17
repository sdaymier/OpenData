# ##################################################################################
# Telechargement des packages:
# ##################################################################################
# - dismo : presente une interface avec Google Maps et permet d'acceder a de nombreux
# jeux de donnees en ligne ;
# - gstat : offre des outils indispensables pour l'interpolation spatiale (krigeage) ;
# - maptools : permet de manipuler les objets spatiaux en creant une classe particuliere
# d'objets spatiaux (planar point pattern) ;
# - raster : offre de nombreuses fonctions permettant de lire et de manipuler les objets
# de type raster ;
# - rgeos : permet de manipuler la geometrie des objets spatiaux ;
# - rgdal : package permettant d'importer/exporter de nombreux formats d'objets spatiaux
# (raster de type grd, GeoTiff, shapefiles ESRI, fichiers KML, etc.) ;
# - sp : package de base definissant des classes d'objets spatiaux et de nombreuses
# fonctions permettant de les manipuler ;
# - spatstat : offre de nombreux outils pour realiser des statistiques spatiales ;
# - spdep : ideal pour etudier l'autocorrelation spatiale, mais aussi pour ce tout qui
# touche a la modelisation spatiale.
# ##################################################################################
lib <- c("classInt"
         , "dismo
         , fields"
         , "gstat"
         , "maptools"
         , "raster"
         , "pgirmess"
         , "rgdal"
         , "rgeos"
         , "sp"
         , "spatstat"
         , "spdep")
for (i in 1:length(lib)) install.packages(lib[i], dependencies = T)

lapply(lib, require, character.only = TRUE)

svg  <- "C:/Users/Admin/Desktop/Sarah_DAYMIER/Adway/Calcul_centroide_distance_R"
# load("C:/Users/Admin/Desktop/Sarah_DAYMIER/Adway/Env_geo.RData")
