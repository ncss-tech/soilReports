### MU GIS Summary Report
### 2016-12-27
### D.E. Beaudette and J. Wood
###
### configuration file, edit as needed


#########################
### Raster Data Sources #
#########################

## 
## raster data, adjust paths and file names, add or remove sources as needed
##
raster.list <- list(`Mean Annual Air Temperature (degrees C)`='climate/PRISM/final_MAAT_800m.tif', 
                    `Mean Annual Precipitation (mm)`='climate/PRISM/final_MAP_mm_800m.tif',
                    `Effective Precipitation (mm)`='climate/PRISM/effective_precipitation_800m.tif',
                    `Frost-Free Days`='climate/PRISM/ffd_mean_800m.tif',
                    `Growing Degree Days (degrees C)`='climate/PRISM/gdd_mean_800m.tif',
                    `Elevation (m)`='MUSum_30m_SSR2/elev_30.tif',
                    `Slope Gradient (%)`='MUSum_30m_SSR2/slope_30.tif',
                    `Slope Aspect (degrees)`='MUSum_30m_SSR2/aspect_30.tif',
                    `Geomorphon Landforms`='elevation/derivatives/forms30_region2.tif',
                    `Curvature Classes`='elevation/derivatives/curvature_classes_30_class_region2.tif',
                    `NLCD 2011`='land_use_land_cover/nlcd_2011_cropped.tif'
)




###################
### Map unit data #
###################

##
## Data are in a large geodatabase with many map units, explicit subsetting
##
# geodatabase path
mu.dsn <- 'L:/CA630/FG_CA630_OFFICIAL.gdb'
# name of featureclass
mu.layer <- 'ca630_a'
# map unit symbols / keys to extract
mu.set <- c('7011', '5012', '7085')



# ##
# ## Typical SDJR style data: SHP with multiple map units
# ##
# # path to SHP
# mu.dsn <- 'testing'
# # SHP name, without file extension
# mu.layer <- 'Mus_for_analysis'
 


############################################
### column with map unit ID / key / symbol #
############################################
mu.col <- 'MUSYM'


#########################################################
### polygon sampling density (samples / acre / polygon) #
#########################################################

# values less < 1 (coarse sampling density) will result in variation between runs, and un-sampled polygons
# values > 10 will result in longer report run times
# details here: http://ncss-tech.github.io/AQP/sharpshootR/sample-vs-population.html
pts.per.acre <- 1



###########################
### quantiles of interest #
###########################
p.quantiles <- c(0.05, 0.1, 0.25, 0.5, 0.75, 0.9, 0.95)


########################################################
### correct sample size for spatial autocorrelation? ###
########################################################
correct.sample.size <- FALSE


###########################################
### save samples after report has run ? ###
###########################################
cache.samples <- FALSE

