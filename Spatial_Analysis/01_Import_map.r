# ##################################################################################
# Import d'objet geographique
# ##################################################################################
# Le package maptools : p. ex., permet de lire des fichiers de type vectoriel (avec la fonction
#                       readShapeSpatial()) ainsi que des rasters (fonction readAsciiGrid()).
# le package rgdal : permet de lire et de manipuler un très grand nombre de formats
#                       matriciels (GeoTIFF, ASCII Grid, etc.) au moyen de différents 
#                       langages de programmation,
# Les fonctions gdalDrivers() et ogrDrivers() : permettent de connaître respectivement 
#                       les formats de données matricielles et vectorielles supportés.
# ##################################################################################

# ##################################################################################
# Les donnees utilisees ont ete telechargees depuis le site http://professionnels.ign.fr/contoursiris
# Depuis l'espace "telechargement"
# ##################################################################################

root <- "C:/Users/Admin/Desktop/Sarah_DAYMIER/Adway/Article/02_Geocodage/Data/R_IRIS/CONTOURS-IRIS_2-0_SHP_LAMB93_FE-2014"

# ##################################################################################
# Importation de la couche IRIS - Paramètres : 
# ##################################################################################
# Ex1 : Avec la librairie MapTools
# ----------------------------------------------------------------------------------
# - dsn qui correspond, dans le cas de données type « ESRI Shapefile » au répertoire
# contenant les fichiers ;
# - layer qui correspond au nom du fichier sans extension.
# ----------------------------------------------------------------------------------

library(maptools)
IR1 <- readShapePoly(file.path(paste0(root,"/CONTOURS-IRIS_FE.shp"))
                           ,proj4string = CRS("+init=epsg:2154")
)

# ----------------------------------------------------------------------------------
# Ex2 : Avec la librairie Rgdal
# ----------------------------------------------------------------------------------
# - dsn qui correspond, dans le cas de données type « ESRI Shapefile » au répertoire
# contenant les fichiers ;
# - layer qui correspond au nom du fichier sans extension.
# ----------------------------------------------------------------------------------

library(rgdal)
IR2 <- readOGR(dsn = root, 
                layer="CONTOURS-IRIS_FE", 
                stringsAsFactors=FALSE)

slotNames(IR2)
# Acceder a la projection : 
IR1@proj4string
head(IR1@data$DEPCOM)

# Pour plus d'information : 
class?SpatialPolygons

# Check caracteristique de projection
# ----------------------------------------------------------------------------------

head(IR1@polygons[[1]]@Polygons[[1]]@coords)
# [,1]    [,2]
# [1,] 667826.5 6888733
# [2,] 667871.5 6888727
# [3,] 667966.4 6888696
# [4,] 668061.2 6888664
# [5,] 668156.1 6888633
# [6,] 668251.0 6888601

# Il faut transformer ces coordonnees en WGS84!

IR1 <- spTransform(IR1, CRS("+init=epsg:4326"))
IR1@proj4string # CRS arguments: +init=epsg:4326 +proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0 
head(IR1@polygons[[1]]@Polygons[[1]]@coords)
# Resultats : 
# [,1]     [,2]
# [1,] 2.559472 49.09762
# [2,] 2.560088 49.09757
# [3,] 2.561390 49.09729
# [4,] 2.562691 49.09701
# [5,] 2.563993 49.09673
# [6,] 2.565294 49.09645

slotNames(IR1@polygons[[1]]@Polygons[[1]])
head(IR1@polygons[[1]]@Polygons[[1]]@coords)


# ##################################################################################
# Exportation - Parametres : 
# ##################################################################################
# Pour exporter un objet vectoriel, nous pouvons utiliser la fonction writeOGR() qui
# accepte plusieurs arguments. Voici ceux qui sont obligatoires :
#   - obj correspond au nom de l'objet vectoriel sous R;
#   - dsn correspond, dans le cas de données type « ESRI Shapefile » au répertoire dans
#     lequel seront écrits nos fichiers ;
#   - layer correspond au nom d'exportation du fichier (sans extension) ;
# ##################################################################################

# Exportation d'un objet SpatialPointDataFrame vectoriel
svg  <- "C:/Users/Admin/Desktop/Sarah_DAYMIER/Adway/Calcul_centroide_distance_R"
writeOGR(obj = tab, dsn = svg, layer = "retailer", driver = "ESRI Shapefile")


