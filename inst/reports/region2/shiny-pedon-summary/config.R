# load packages
library(aqp)
library(soilDB)
library(sharpshootR)

library(rgdal)
library(raster)
library(leaflet)
library(mapview)

library(xtable)
library(knitr)
library(latticeExtra)
library(rmarkdown)

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

options(p.low.rv.high=p.low.rv.high, q.type=q.type, 
        ml.profile.smoothing=ml.profile.smoothing)

# "generic" gen.hz.rules
#   TODO: handle caret, primes etc.
gen.hz.rules.generic <- list(
  n = c('Oi',
        'A',
        'BA',
        'Bt',
        'Bw',
        'Btqm',
        'Btg',
        'Bss',
        'BC',
        'BCg',
        'C',
        'Cr'),
  p = c('O',
        '^[2-9]?[AE]B?C?p?d?t?[1-9]?$',
        '^[2-9]?BA?E?t?[1-9]?$',
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

# path to folder or geodatabase
poly.dsn = "."
# layer or shapefile name (without .shp)
poly.layer = "gopheridge_spatial"
# bounding polygon layer (currently not used)
poly.bounds = "ca630_b"

if(!cache_data) {
  if(demo_mode) {
    # load two datasets from soilDB
    data("loafercreek", package="soilDB")
    data("gopheridge", package="soilDB")
    loafergopher <- aqp::union(list(loafercreek, gopheridge))
    
    hzidname(loafergopher) <- 'phiid'
    
    loafergopher$musym <- rep('<missing>', length(loafergopher))  
    loafergopher$taxonname <- factor(loafergopher$taxonname)
    
    pedons_raw <- loafergopher
  } else {
    pedons_raw <- fetchNASIS()
  }
  
  if(use_regex_ghz | !("genhz" %in% horizonNames(pedons_raw)))
    pedons_raw$genhz <- factor(aqp::generalize.hz(as.character(pedons_raw$hzname), 
                                            new = gen.hz.rules.generic$n,
                                            pat = gen.hz.rules.generic$p))
  
  
  #components <- try(fetchNASIS('components'))
  
  mu <- try(readOGR(dsn = poly.dsn, layer = poly.layer, stringsAsFactors=FALSE))
  
  rasters <- try(list(
    # gis_ppt=raster('L:/NRCS/MLRAShared/Geodata/climate/raster/final_MAP_mm_800m.tif'),
    # gis_tavg=raster('L:/NRCS/MLRAShared/Geodata/climate/raster/final_MAAT_800m.tif'),
    # gis_ffd=raster('L:/NRCS/MLRAShared/Geodata/climate/raster/ffd_mean_800m.tif'),
    # gis_gdd=raster('L:/NRCS/MLRAShared/Geodata/climate/raster/gdd_mean_800m.tif'),
    # gis_elev=raster('L:/NRCS/MLRAShared/Geodata/DEM_derived/elevation_30m.tif'),
    # gis_solar=raster('L:/NRCS/MLRAShared/Geodata/DEM_derived/beam_rad_sum_mj_30m.tif'),
    # gis_mast=raster('S:/NRCS/Archive_Dylan_Beaudette/CA630-models/hobo_soil_temperature/spatial_data/mast-model.tif'),
    # gis_slope=raster('L:/NRCS/MLRAShared/Geodata/elevation/10_meter/ca630_slope'),
    gis_geomorphons=raster('L:/NRCS/MLRAShared/Geodata/project_data/MUSum_Geomorphon/forms30_region2.tif')
  ))
}


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
