# ##################################################################################
# Geocoder with R
# ##################################################################################
# Author : Mlle DAYMIER Sarah
# Date   : 17/01/2017
# ##################################################################################

# ##################################################################################
# 0 - Importer les fonctions, installer les librairies ...
# ##################################################################################

# ----------------------------------------------------------------------------------
# Chargement des packages : 
# ----------------------------------------------------------------------------------

library(dismo) 
library(ggmap)

# ----------------------------------------------------------------------------------
# Chargement des fonctions R personnelles (enregistree dans un autre fichier .R)
# ----------------------------------------------------------------------------------

root = "C:/Users/Admin/Desktop/Sarah_DAYMIER/Livrable_BNP/01_Livrables/Note Methodo"
source(paste0(root,"/03a_Geocoder_R_Fonctions.R"))

# ----------------------------------------------------------------------------------
# Definition du repertoire de sauvegarde
# ----------------------------------------------------------------------------------

setwd(root)

# ----------------------------------------------------------------------------------
# Acces documentation
# ----------------------------------------------------------------------------------
library(dismo)
str(geocode)
library(ggmap)
str(geocode)

# ##################################################################################
# Geocoder un point d'interet
# ##################################################################################

# >>> Utilisation de la fonction "geocode" de la librairie "ggmap"
eiffel.latlon <- geocode("Tour Eiffel, France")

# >>> Affichage et retraitement des resultats
class(eiffel.latlon) # "data.frame"

# ##################################################################################
# Geocoder une adresse
# ##################################################################################

# >>> Enregistrer une adresse a géocoder
addresses <- c("37 Boulevard GARIBALDI, 75015 PARIS, France")

# >>> Utilisation de la fonction "geocode" de la librairie "ggmap"
adres.latlon <- geocode(addresses)

# >>> Affichage et retraitement des resultats
class(adres.latlon) # "data.frame"

# ##################################################################################
# Obtenir plus d'information sur les résultats de géocodage
# ##################################################################################

geo_reply = geocode(addresses, 
                    source = "google",
                    override_limit=TRUE, 
                    output='all')

class(geo_reply)  # list

class(geo_reply$status)  # character
class(geo_reply$results) # List

# Type des objets présents dans la liste geo_reply$results[[1]]
class(geo_reply$results[[1]]$address_components) # List
class(geo_reply$results[[1]]$formatted_address)  # character
class(geo_reply$results[[1]]$geometry)           # List
class(geo_reply$results[[1]]$place_id)           # character
class(geo_reply$results[[1]]$types)              # character

# Contenu de la liste "address_components"
str(geo_reply$results[[1]]$address_components)

# Contenu de la liste "address_components"
str(geo_reply$results[[1]]$geometry)

# ##################################################################################
# 2 - Geocoder plusieurs adresses - Appel d'une fonction
# ##################################################################################

addresses = c("41 Rue du Dr Roux, 75015 Paris, France", 
              "Tour Eiffel",
              "Parc Montsouris",
              "66 Rue du President Wilson, 92300 Levallois-Perret", 
              "20 Boulevard de Vaugirard, 75015 Paris",
              "Gare Montparnasse",
              "59 Avenue d'Italie, 75013 Paris")

# 2a - Geocodage avec GoogleMaps
# ------------------------------------------------------------------------
infile <- root
geo <- function_geo_GoogleMaps(addresses)
