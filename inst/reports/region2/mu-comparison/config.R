### MU GIS Summary Report
### 2017-02-08
### D.E. Beaudette and J. Wood
###
### configuration file, edit as needed
###

#########################
### Raster Data Sources #
#########################

# data sources can be "commented-out" using the "#" character
# be sure that there is no trailing "," after the last item in each list
# raster summaries are displayed in the same order in which they are listed below

raster.list <- list(
  continuous=list(
    `Mean Annual Air Temperature (degrees C)`='L:/NRCS/MLRAShared/Geodata/climate/raster/final_MAAT_800m.tif', 
    `Mean Annual Precipitation (mm)`='L:/NRCS/MLRAShared/Geodata/climate/raster/final_MAP_mm_800m.tif', 
    `Effective Precipitation (mm)`='L:/NRCS/MLRAShared/Geodata/climate/raster/effective_precipitation_800m.tif',
    `Frost-Free Days`='L:/NRCS/MLRAShared/Geodata/climate/raster/ffd_mean_800m.tif',
    `Growing Degree Days (degrees C)`='L:/NRCS/MLRAShared/Geodata/climate/raster/gdd_mean_800m.tif',
    `Elevation (m)`='L:/NRCS/MLRAShared/Geodata/elevation/10_meter/ca630_elev',
    `Slope Gradient (%)`='L:/NRCS/MLRAShared/Geodata/elevation/10_meter/ca630_slope',
    `Rain Fraction`='L:/NRCS/MLRAShared/Geodata/climate/raster/rain_fraction_mean_800m.tif',
    `Annual Beam Radiance (MJ/sq.m)`='L:/NRCS/MLRAShared/Geodata/DEM_derived/beam_rad_sum_mj_30m.tif',
    `(Estimated) MAST (degrees C)`='E:/geodata/ca630/soil_temperature/spatial_data/mast-model.tif',
    `Compound Topographic Index`='L:/NRCS/MLRAShared/Geodata/DEM_derived/tci30.tif',
    `SAGA TWI`='L:/NRCS/MLRAShared/Geodata/DEM_derived/saga_twi_10.tif',
    `K40 percentage`='L:/NRCS/MLRAShared/Geodata/Radiometric/namrad_k_aea.tif'
  ),
  categorical=list(
    `R1056ness`='E:/workspace/r1056ness_ras',
    `Geomorphon Landforms`='L:/NRCS/MLRAShared/Geodata/DEM_derived/forms10.tif',
    `Curvature Classes`='L:/NRCS/MLRAShared/Geodata/DEM_derived/curvature_classes_15.tif',
    `NLCD`='L:/NRCS/MLRAShared/Geodata/NLCD/nlcd_ca630',
    `Mesic Thermic Uncertainty`='S:/NRCS/Archive_Dylan_Beaudette/CA630-models/hobo_soil_temperature/spatial_data/mast-model-mesic_thermic-uncertainty.tif'
  ),
  circular=list(
    `Slope Aspect (degrees)`='L:/NRCS/MLRAShared/Geodata/DEM_derived/ca630_aspect'
  )
)



###################
### Map unit data #
###################

##
## Data must be in a projected coordinate system, with units of meters!
##

##
## Geodatabase with many map units, explicit subsetting
## consider sub-setting to SHP if the geodatabase contains more than 2-3 soil survey areas
##

# geodatabase path
# mu.dsn <- 'E:/gis_data/ca630/FG_CA630_OFFICIAL.gdb'
# name of featureclass
# mu.layer <- 'ca630_a'
# map unit symbols / keys to extract
 mu.set <- c('6072','6071','6205','6034')



##
## Typical SDJR style data: SHP with multiple map units
##

# path to SHP
mu.dsn <- 'L:/NRCS/MLRAShared/CA630/FG_CA630_OFFICIAL.gdb'
# SHP name, without file extension
mu.layer <- 'ca630_a'
 


############################################
### column with map unit ID / key / symbol #
############################################

# could be 'MUKEY', 'MUSYM', or any valid column name
mu.col <- 'MUSYM'


#########################################################
### polygon sampling density (samples / acre / polygon) #
#########################################################

# consider using a sampling density between 1-2 points / ac.
# increase if there are un-sampled polygons
# delineations smaller than 5 ac. may require up to 5 points / ac.
# values > 6-7 points / ac. will only slow things down
pts.per.acre <- 0.01



###########################
### quantiles of interest #
###########################

# the most important quantiles (percentiles / 100) are: 0.1, 0.5 (median), and 0.9
# optionally reduce the number of quantiles for narrower tables
p.quantiles <- c(0.05, 0.1, 0.25, 0.5, 0.75, 0.9, 0.95)


########################################################
### Add estimate of confidence to box and whisker plots ###
########################################################

#enabling this feature will double the run time 
#enabling this feature will add "notches" to box and whisker plots
# that are close approximations to a confidence interval around the median
# adjusted for spatial autocorrelation
correct.sample.size <- FALSE


###########################################
### save samples after report has run ? ###
###########################################

# used for tinkering with a report .Rmd and debugging
# this will save samples to a file and subsequent report runs will use the saved samples
# not recommended for routine operation
cache.samples <- FALSE

