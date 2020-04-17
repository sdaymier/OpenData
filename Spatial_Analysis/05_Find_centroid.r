# ##################################################################################
# Calcul centroide
# ##################################################################################

# ----------------------------------------------------------------------------------
# Chargement des packages : 
# ----------------------------------------------------------------------------------
library(rgdal)
library(rgeos)
library(data.table)

# ----------------------------------------------------------------------------------
# Importation carte : 
# ----------------------------------------------------------------------------------
root <- "C:/Users/Admin/Desktop/Sarah_DAYMIER/Adway/Article/02_Geocodage/Data/R_IRIS/CONTOURS-IRIS_2-0_SHP_LAMB93_FE-2014"
IR1 <- readOGR(dsn = root, 
               layer="CONTOURS-IRIS_FE", 
               stringsAsFactors=FALSE)

# ----------------------------------------------------------------------------------
# Reduction de la carte
# ----------------------------------------------------------------------------------

head(IR1@data)
pos               <- which(IR1@data [, "DEPCOM"] %like% '^31.*?')
DEP31             <- IR1[pos, ]

class(DEP31) # SpatialPolygonsDataFrame

# Verification du CRS
DEP31@proj4string
# CRS arguments:
# +proj=lcc +lat_1=44 +lat_2=49 +lat_0=46.5 +lon_0=3 +x_0=700000 +y_0=6600000
# +ellps=GRS80 +units=m +no_defs 

# Affichage de la carte
plot(DEP31, main = "Contour IRIS - Departement 31")



# ##################################################################################
# Calcul centroide
# ##################################################################################

trueCentroids = gCentroid(DEP31,byid=TRUE)
class(trueCentroids)

trueCentroids@proj4string
# CRS arguments:
# +proj=lcc +lat_1=44 +lat_2=49 +lat_0=46.5 +lon_0=3 +x_0=700000 +y_0=6600000
# +ellps=GRS80 +units=m +no_defs 

# Affichage sur la même carte que précédemment
plot(DEP31, pch = 30, 
     main = "Contour IRIS - Departement 31",
     sub = "Avec centroide")
points(trueCentroids,
       pch=0, 
       type = "p",
       col = "red")
?points

