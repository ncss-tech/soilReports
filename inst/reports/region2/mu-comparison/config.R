### MU GIS Summary Report
### 2017-01-19
### D.E. Beaudette and J. Wood
###
### configuration file, edit as needed
###


#########################
### Raster Data Sources #
#########################

# data sources can be "commented-out" using the "#" character
# be sure that there is no trailing "," after the last item in each list

raster.list <- list(
  continuous=list(
    `Mean Annual Air Temperature (degrees C)`='E:/gis_data/prism/final_MAAT_800m.tif', 
    `Mean Annual Precipitation (mm)`='E:/gis_data/prism/final_MAP_mm_800m.tif',
    `Effective Precipitation (mm)`='E:/gis_data/prism/effective_precipitation_800m.tif',
    `Frost-Free Days`='E:/gis_data/prism/ffd_mean_800m.tif',
    `Growing Degree Days (degrees C)`='E:/gis_data/prism/gdd_mean_800m.tif',
    `Elevation (m)`='E:/gis_data/region-2-mu-analysis/elev_30.tif',
    `Slope Gradient (%)`='E:/gis_data/region-2-mu-analysis/slope_30.tif',
    `Annual Beam Radiance (MJ/sq.m)`='E:/gis_data/ca630/beam_rad_sum_mj_30m.tif',
    `(Estimated) MAST (degrees C)`='E:/gis_data/ca630/mast-model.tif'
    # `Compound Topographic Index`='E:/gis_data/ca630/tci30.tif',
    # `MRVBF`='E:/gis_data/ca630/mrvbf_10.tif',
    # `SAGA TWI`='E:/gis_data/ca630/saga_twi_10.tif'
  ),
  categorical=list(
    `Geomorphon Landforms`='E:/gis_data/region-2-mu-analysis/forms10_region2.tif',
    `Curvature Classes`='E:/gis_data/region-2-mu-analysis/curvature_classes_10_class_region2.tif',
    `NLCD 2011`='E:/gis_data/region-2-mu-analysis/nlcd_2011_cropped.tif'
  ),
  circular=list(
    `Slope Aspect (degrees)`='E:/gis_data/region-2-mu-analysis/aspect_30.tif'
    )
)


###################
### Map unit data #
###################

##
## Data are in a geodatabase with many map units, explicit subsetting
## Note: consider sub-setting to SHP if the geodatabase contains more than 2-3 soil survey areas
##

# geodatabase path
mu.dsn <- 'E:/gis_data/ca630/FG_CA630_OFFICIAL.gdb'
# name of featureclass
mu.layer <- 'ca630_a'
# map unit symbols / keys to extract
mu.set <- c('7011', '5012', '7089')



# ##
# ## Typical SDJR style data: SHP with multiple map units
# ##

# # path to SHP
# mu.dsn <- 'testing'
# # SHP name, without file extension
# mu.layer <- 'MUs_for_analysis'
 


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
pts.per.acre <- 1



###########################
### quantiles of interest #
###########################

# the most important quantiles (percentiles / 100) are: 0.1, 0.5 (median), and 0.9
# optionally reduce the number of quantiles for narrower tables
p.quantiles <- c(0.05, 0.1, 0.25, 0.5, 0.75, 0.9, 0.95)


########################################################
### correct sample size for spatial autocorrelation? ###
########################################################

# enabling this feature will add "notches" to box and whisker plots
# that are close approximations to a confidence interval around the median
# adjusted for spatial autocorrelation
#
# enabling this feature will double the run time
correct.sample.size <- FALSE


###########################################
### save samples after report has run ? ###
###########################################

# used for tinkering with a report .Rmd and debugging
# this will save samples to a file and subsequent report runs will use the saved samples
# not recommended for routine operation
cache.samples <- FALSE

