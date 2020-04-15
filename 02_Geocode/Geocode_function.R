# #######################################################################
# Geocoder with R
# #######################################################################
#                     FONCTIONS 
# #######################################################################

# #######################################################################
# GoogleMAPS
# #######################################################################

# Define a function that will process googles server responses for us.
# -----------------------------------------------------------------------
getGeoDetails <- function(address){   
  #use the gecode function to query google servers
geo_reply = geocode(address, 
                    source = "google",
                    output='all', 
                    messaging=TRUE, 
                    override_limit=TRUE)
  
  # Construction de la base de données où seront enregistrés les résultats obtenus avec la fonction "geocode"
  answer <- data.frame(lat=NA, 
                       long=NA, 
                       accuracy=NA, 
                       formatted_address=NA, 
                       address_type=NA, 
                       status=NA)
  
  # Enregistrement du statut de la requete précédente
  answer$status <- geo_reply$status
    
  #if we are over the query limit - want to pause for an hour
  while(geo_reply$status == "OVER_QUERY_LIMIT"){
    print("OVER QUERY LIMIT - Pausing for 1 hour at:") 
    time <- Sys.time()
    print(as.character(time))
    Sys.sleep(60*60)
    geo_reply = geocode(address, 
                        source = "google",
                        output='all', 
                        messaging=TRUE, 
                        override_limit=TRUE)
    answer$status <- geo_reply$status
  }
  
  # return Na's if we didn't get a match:
  if (geo_reply$status != "OK"){
    return(answer)
  }   
  
  # Affecter les différents éléments qui nous interesse dans le 
  # dataframe que l'on a précédemment initialisé 
  answer$lat               <- geo_reply$results[[1]]$geometry$location$lat
  answer$long              <- geo_reply$results[[1]]$geometry$location$lng   
  if (length(geo_reply$results[[1]]$types) > 0){
    answer$accuracy        <- geo_reply$results[[1]]$types[[1]]
  }
  answer$address_type      <- paste(geo_reply$results[[1]]$types, collapse=',')
  answer$formatted_address <- geo_reply$results[[1]]$formatted_address
  
  # Sauvegarde des resultats
  return(answer)
}

# Macro Function

function_geo_GoogleMaps <- function(addresses, 
                                    init = 1,
                                    delay = 5){
  
  # initialise a dataframe to hold the results
  geocoded          <- data.frame()
  

  #if a temp file exists - load it up and count the rows!
  tempfilename <- paste0('temp_geocoded.rds') # le fichier temporaire va s'enregistrer dans le setwd définis en amont
  if (file.exists(tempfilename)){
    print("Found temp file - resuming from index:")
    geocoded <- readRDS(tempfilename)
    startindex <- nrow(geocoded)
    print(startindex)
  }
  dir()
  # Start the geocoding process - address by address. 
  # geocode() function takes care of query speed limit.
  
  for (ii in seq(init, length(addresses))){
      print(paste("Working on index", ii, "of", length(addresses)))
    
      #query the google geocoder - this will pause here if we are over the limit.
      Sys.sleep(delay)
      
      # lancement du géocodage pour l'adresse numero ii
      result          <- getGeoDetails(address = addresses[ii]) 
      print(result$status)     
      
      result$index    <- ii
      
      #append the answer to the results file.
      geocoded <- rbind(geocoded, result)
      
      
      #save temporary results as we are going along
      saveRDS(geocoded, tempfilename)
  }
  return(geocoded)
}
