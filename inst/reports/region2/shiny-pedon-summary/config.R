library(soilDB)
library(sharpshootR)
library(rgdal)
library(raster)
library(leaflet)
library(mapview)
library(latticeExtra)
library(rmarkdown)
library(plyr)
library(reshape2)
library(xtable)
library(knitr)

cache_data=F
use_regex_ghz=T

#these are defaults to ensure that the report has inputs necessary to generate plots on startup
input <- data.frame(1) #create input dataframe
input$s.mu = '.' #all mapunits
input$pedon_list="" #no pedon list specified (no initial filter)

# "generic" gen.hz.rules for CA630 use
#   TODO: handle caret, primes etc.
gen.hz.rules <- list(list(
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
))


poly.dsn = "L:/NRCS/MLRAShared/CA630/FG_CA630_OFFICIAL.gdb"
poly.layer = "ca630_a"
poly.bounds = "ca630_b"

p.low.rv.high <- c(0.05, 0.5, 0.95)
q.type <- 7
ml.profile.smoothing <- 0.65
options(p.low.rv.high=p.low.rv.high, q.type=q.type, ml.profile.smoothing=ml.profile.smoothing)

rasters <- list(
  gis_ppt=raster('L:/NRCS/MLRAShared/Geodata/climate/raster/final_MAP_mm_800m.tif'),
  gis_tavg=raster('L:/NRCS/MLRAShared/Geodata/climate/raster/final_MAAT_800m.tif'),
  gis_ffd=raster('L:/NRCS/MLRAShared/Geodata/climate/raster/ffd_mean_800m.tif'),
  gis_gdd=raster('L:/NRCS/MLRAShared/Geodata/climate/raster/gdd_mean_800m.tif'),
  gis_elev=raster('L:/NRCS/MLRAShared/Geodata/DEM_derived/elevation_30m.tif'),
  gis_solar=raster('L:/NRCS/MLRAShared/Geodata/DEM_derived/beam_rad_sum_mj_30m.tif'),
  gis_mast=raster('S:/NRCS/Archive_Dylan_Beaudette/CA630-models/hobo_soil_temperature/spatial_data/mast-model.tif'),
  gis_slope=raster('L:/NRCS/MLRAShared/Geodata/elevation/10_meter/ca630_slope'),
  gis_geomorphons=raster('L:/NRCS/MLRAShared/Geodata/DEM_derived/forms10.tif')
)