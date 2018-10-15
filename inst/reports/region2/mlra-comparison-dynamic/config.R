### Dynmamic MLRA Summary Report
### 2018-05-29
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
    `Mean Annual Air Temperature (degrees C)`='L:/NRCS/MLRAShared/Geodata/project_data/MUSum_PRISM/final_MAAT_800m.tif',
    `Mean Annual Precipitation (mm)`='L:/NRCS/MLRAShared/Geodata/project_data/MUSum_PRISM/final_MAP_mm_800m.tif',
    `Effective Precipitation (mm)`='L:/NRCS/MLRAShared/Geodata/project_data/MUSum_PRISM/effective_precipitation_800m.tif',
    `Frost-Free Days`='L:/NRCS/MLRAShared/Geodata/project_data/MUSum_PRISM/ffd_50_pct_800m.tif',
    `Growing Degree Days (degrees C)`='L:/NRCS/MLRAShared/Geodata/project_data/MUSum_PRISM/gdd_mean_800m.tif',
    `Elevation (m)`='L:/NRCS/MLRAShared/Geodata/project_data/MUSum_30m_SSR2/DEM_30m_SSR2.tif'
  ),
  categorical=list(
    `Geomorphon Landforms`='L:/NRCS/MLRAShared/Geodata/project_data/MUSum_Geomorphon/forms30_region2.tif',
    `NLCD (2011)`='L:/NRCS/MLRAShared/Geodata/project_data/nlcd_2011_cropped.tif',
    `NASS Cropland Data Layer (2017)`='L:/NRCS/MLRAShared/Geodata/project_data/NASS/Ver2017_30m_cdls_clip.img'
  )
)

###################
# MLRA / LRU Data #
###################

##
## Data must be in a projected coordinate system, with units of meters!
##


# geodatabase path
# mu.dsn <- 'E:/gis_data/ca630/FG_CA630_OFFICIAL.gdb'
# name of featureclass
# mu.layer <- 'ca630_a'
# map unit symbols / keys to extract
# mu.set <- c('5012','5013','7011')



##
## Shapefiles
##

# path to parent folder of SHP, no trailing forward slash (/)
mu.dsn <- 'E:/gis_data/MLRA'
# SHP name, without file extension
mu.layer <- 'conus-mlra-v42'
# subset
mu.set <- c('15','18')


############################################
### column with map unit ID / key / symbol #
############################################

# this is the field the groups features, MLRA, LRU, etc.
# should not be longer than 15 characters
mu.col <- 'MLRARSYM'


#########################################################
### polygon sampling density (samples / acre / polygon) #
#########################################################

# MLRA: start with 0.0001
# LRU: start with 0.001
pts.per.acre <- 0.0001

###########################
### quantiles of interest #
###########################

# the most important quantiles (percentiles / 100) are: 0.1, 0.5 (median), and 0.9
# optionally reduce the number of quantiles for narrower tables
p.quantiles <- c(0, 0.01, 0.05, 0.1, 0.25, 0.5, 0.75, 0.9, 0.95, 0.99, 1)


##################################
### scale density plots to {0,1} #
##################################

# typically scaling density curves to the interval of {0,1} is helpful: patterns are more clear
# this can cause problems when comparing map units of drastically different areas
# in that case, it might be useful to disable scaling
scaleDensityCurves <- TRUE


#####################################################################################
### output file names (OPTIONAL; uncomment to override defaults)                    #
### default will include a file-specific prefix and full list of MUSYMs summarized  #
#####################################################################################

# csv.stats.fname <- 'poly-stats.csv' # comma-separated value file containing median values / most likely classes by delineation
# csv.qc.fname <- 'poly-qc.csv' # comma-separated value file containing "proportion of samples outside 5-95% quantile range" by delineation

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

