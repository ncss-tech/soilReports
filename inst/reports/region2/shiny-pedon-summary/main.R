###### LOAD DATA

#TODO: revise specification of raster paths to MUCOMP style, save loading until main.R
pedons_raw <- NULL
if(!any(file.exists(c("pedon_cache.Rda","component_cache.Rda","spatial_cache.Rda"))) | !cache_data) { 
  #if there is no cache or caching is turned off, load pedons from nasis
  pedons_raw <- fetchNASIS(rmHzErrors=F)
  components <- get_component_data_from_NASIS_db()
  mu <- readOGR(dsn = poly.dsn, layer = poly.layer, stringsAsFactors=FALSE)

  #data transforms and extractions
  good.idx <- which(!is.na(pedons_raw$x_std)) # may be too restrictive, assumes UTMs are populated in NASIS
  pedons <- pedons_raw[good.idx, ]            # keep only pedons with non-NA UTM coordinates
  
  coordinates(pedons) <- ~ x_std + y_std      #initalize spatial object
  proj4string(pedons) <- '+proj=longlat +datum=NAD83' # set spatial reference
  pedons_spdf <- as(pedons, 'SpatialPointsDataFrame') # extract spatial data + site level attributes for each pedon
  
  pedons_spdf <- spTransform(pedons_spdf,proj4string(mu)) #transform to polygon coordinate reference system
  musymz <- (pedons_spdf %over% mu)$MUSYM #do the overlay on linework
  
  site(pedons)$MUSYM <- musymz  #note that this copies the MUSYM attribute back to the __non-transformed__ SPC object.
  pedons_spdf$MUSYM <- musymz   #makes sure musym is also available in the SPDF site-level object. this object should be used for plotting spatial data!
  
  #attach raster data to site-level data of SPC
  pedons_spdf <- spTransform(pedons_spdf,proj4string(rasters[[1]])) #transform to raster coordinate reference system (assumes common between all rasters)
  l.res <- lapply(rasters, extract, pedons_spdf) #do the extraction
  l.res <- as.data.frame(l.res, stringsAsFactors=FALSE)
  l.res$peiid <- pedons_spdf$peiid
  site(pedons) <- l.res
  pedons$gis_geomorphons <- factor(pedons$gis_geomorphons, levels=1:10, labels=c('flat', 'summit', 'ridge', 'shoulder', 'spur', 'slope', 'hollow', 'footslope', 'valley', 'depression'))
  
  if(cache_data) {#if there was no cache but caching is on, save the data for next time
    save(pedons,file = "pedon_cache.Rda") 
    save(components,file="component_cache.Rda")
    save(mu,file="spatial_cache.Rda")
  }
} else if (file.exists("pedon_cache.Rda")) { #if there is a cache...
   if(cache_data) { # and caching is ON, load the data from file rather than NASIS
     load("pedon_cache.Rda")
     load("component_cache.Rda")
     load("spatial_cache.Rda")
     print("Loaded data from cache.")
   } else { # and caching is OFF, make it a backup (AKA clear cache after turning off caching)
     file.rename(from="pedon_cache.Rda",to="pedon_cache.Rda.bak")
     file.rename(from="component_cache.Rda",to="component_cache.Rda.bak")
     file.rename(from="spatial_cache.Rda",to="spatial_cache.Rda.bak")
   }
}

#assumed that these do not significantly affect load time performance; could Rda this data aswell, readOGR takes a little time for large GDB
components <- get_component_data_from_NASIS_db()
s.comp=comp.pedons=data.frame()
######