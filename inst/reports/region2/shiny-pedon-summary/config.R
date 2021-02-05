# load packages
library(aqp)
library(soilDB)
library(sharpshootR)

library(rgdal)
library(raster)
library(leaflet)
library(mapview)
library(leafem)

library(xtable)
library(knitr)
library(latticeExtra)
library(rmarkdown)
library(shiny)
library(DT)

library(plyr)
library(reshape2)

### set options
  # in demo mode, loafercreek and gopheridge datasets are used from soilDB
  demo_mode <- FALSE
  
  # store pedons etc in Rda files?
  cache_data <- FALSE
  
  # use regex-assigned generalized horizons?
  # default uses gen.hz.rules.generic defined below
  # TODO: allow compname/regex-pattern specific gen.hz.rules to be defined
  use_regex_ghz <- TRUE
  
  # probability levels for quantile l-rv-h
  p.low.rv.high <- c(0.05, 0.5, 0.95)
  
  # quantile type
  q.type <- 7
  
  # maximum-likelihood horizon curve smoothing parameter
  ml.profile.smoothing <- 0.65

  options(
    p.low.rv.high = p.low.rv.high,
    q.type = q.type,
    ml.profile.smoothing = ml.profile.smoothing
  )

# "generic" gen.hz.rules
#   TODO: handle caret, primes, virgule etc.
gen.hz.rules.generic <- list(
  n = c('Oi',
        'A',
        'E',
        'BA',
        'Bt',
        'Bw',
        'Btqm',
        'Bg',
        'Bss',
        'BC',
        'BCg',
        'C',
        'Cr'),
  p = c('O',
        '^[2-9]?AB?C?p?d?t?[1-9]?$',
        'E',
        '^[2-9]?BA?t?[1-9]?$',
        '^[2-9]?Btb?[1-9]?$',
        '^[2-9]?Bw[1-9]?$',
        '^[2-9]?Btqc?m?[1-9]?$',
        '^[2-9]?Bt?g[1-9]?$',
        '^[2-9]?B.*ss.*[1-9]?$',
        '^[2-9]?BCt?c?[1-9]?$',
        '^[2-9]?BCt?c?g[1-9]?$',
        '^[2-9]?C[^r]?t?[1-9]?$',
        '^[2-9]?(C[dr]t?|Rt?)[1-9]?')
)

# mapview options
mapviewOptions(basemaps = mapviewGetOption("basemaps")[c(4, 5, 3)])

# path to folder or geodatabase
poly.dsn <- "/home/andrew/geodata/soils/loafergopher"

# layer or shapefile name (without .shp)
poly.layer <- "loafergopher"

# column name for group (musym) in shapefile
musym.col <- "ntnlmsy"

# bounding polygon layer (currently not used)
poly.bounds <- "ca630_b"

if(!cache_data) {
  if(demo_mode) {
    # load two datasets from soilDB
    data("loafercreek", package="soilDB")
    data("gopheridge", package="soilDB")
    
    site(loafercreek)$mollic.epipedon <- FALSE
    
    loafergopher <- aqp::combine(loafercreek, gopheridge)
    
    hzidname(loafergopher) <- 'phiid'
    
    loafergopher$musym <- rep('<missing>', length(loafergopher))  
    loafergopher$taxonname <- factor(loafergopher$taxonname)
    
    pedons_raw <- loafergopher
  } else {
    pedons_raw <- fetchNASIS()
  }
  
  if (use_regex_ghz | !("genhz" %in% horizonNames(pedons_raw))) {
    pedons_raw$genhz <- factor(
        aqp::generalize.hz(
          as.character(pedons_raw$hzname),
          new = gen.hz.rules.generic$n,
          pat = gen.hz.rules.generic$p
        )
      )
  }
  
  #components <- try(fetchNASIS('components'))
  
  mu <- try(readOGR(dsn = poly.dsn,
                    layer = poly.layer,
                    stringsAsFactors = FALSE))
      
  rasters <- try(list(
    # gis_ppt=raster('L:/NRCS/MLRAShared/Geodata/climate/raster/final_MAP_mm_800m.tif'),
    # gis_tavg=raster('L:/NRCS/MLRAShared/Geodata/climate/raster/final_MAAT_800m.tif'),
    # gis_ffd=raster('L:/NRCS/MLRAShared/Geodata/climate/raster/ffd_mean_800m.tif'),
    # gis_gdd=raster('L:/NRCS/MLRAShared/Geodata/climate/raster/gdd_mean_800m.tif'),
    # gis_elev=raster('L:/NRCS/MLRAShared/Geodata/DEM_derived/elevation_30m.tif'),
    # gis_solar=raster('L:/NRCS/MLRAShared/Geodata/DEM_derived/beam_rad_sum_mj_30m.tif'),
    # gis_mast=raster('S:/NRCS/Archive_Dylan_Beaudette/CA630-models/hobo_soil_temperature/spatial_data/mast-model.tif'),
    # gis_slope=raster('L:/NRCS/MLRAShared/Geodata/elevation/10_meter/ca630_slope'),
    # gis_geomorphons=raster('L:/NRCS/MLRAShared/Geodata/project_data/MUSum_Geomorphon/forms30_region2.tif')
  ))
}

# keep only pedons with non-NA coord
good.idx <- which(!is.na(pedons_raw$x_std)) 
pedons <- pedons_raw[good.idx, ]           

#initalize spatial object
coordinates(pedons) <- ~ x_std + y_std     

# set spatial reference
proj4string(pedons) <- '+proj=longlat +datum=WGS84'

pedons$musym <- rep("<missing>", length(pedons))

# extract spatial data + site level attributes for each pedon
pedons_spdf <- as(pedons, 'SpatialPointsDataFrame')

if(!inherits(mu, 'try-error')) {
  #transform to polygon coordinate reference system
  pedons_spdf <- spTransform(pedons_spdf, proj4string(mu)) 
  
  # do the overlay on linework
  musymz <- (pedons_spdf %over% mu)[[musym.col]]
  
  # note: that this copies the MUSYM attribute back to the
  # __non-transformed__ SPC object.
  pedons$MUSYM <- musymz  
  pedons$musym <- musymz
  
  #makes sure musym is also available in the SPDF object. 
  pedons_spdf$MUSYM <- musymz  
  pedons_spdf$musym <- musymz
}

pedons$musym <- factor(pedons$musym)
pedons$taxonname <- factor(pedons$taxonname)

#these are defaults to ensure that the report won't error on startup
# you can adjust them if you have a preset pattern in mind, 
# ...but do so at your own risk
input <- list()
input$pedon_pattern <- ".*"
input$upid_pattern <- ".*"
input$pedon_list <- ".*"
input$taxon_kind <- ".*"
input$phase_pattern <- ".*"
input$modal_pedon <- NA
input$thematic_field <- "clay"
input$s.mu <- '.*' #all mapunits
input$pedon_list <- "" #no pedon list specified (no initial filter)
