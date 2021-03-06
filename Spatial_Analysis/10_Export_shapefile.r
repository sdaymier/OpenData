# ##################################################################################
# Exporter des donnees spatiales
#                           Exemple avec les Open Data Pologne
# ##################################################################################
# Objectif : 
# ----------------------------------------------------------------------------------
# Creer son propre fichier Shapefile
# ##################################################################################

# ----------------------------------------------------------------------------------
# Chargement des packages : 
# ----------------------------------------------------------------------------------
library(rgdal)

# ##################################################################################
#                        *** Faire des traitements ***
# ##################################################################################

root <- "C:/Users/Admin/Desktop/Sarah_DAYMIER/Livrable_BNP/02_BDD/Data_Poland"
setwd(root)

# write out a new shapefile (including .prj component)
writeOGR(wojewodztwaWGS, ".", "voivod_with_OD", driver="ESRI Shapefile")
