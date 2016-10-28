### MU GIS Summary Report
### 2016-04-07
### D.E. Beaudette and J. Wood
###
### configuration file, edit as needed


#########################
### Raster Data Sources #
#########################

## 
## raster data used for CA630, adjust as needed
##
raster.list <- list(`Mean Annual Air Temperature (degrees C)`='E:/gis_data/prism/final_MAAT_800m.tif', 
                    `Mean Annual Precipitation (mm)`='E:/gis_data/prism/final_MAP_mm_800m.tif',
                    `Effective Precipitation (mm)`='E:/gis_data/prism/effective_precipitation_800m.tif',
                    `Frost-Free Days`='E:/gis_data/prism/ffd_mean_800m.tif',
                    `Growing Degree Days (degrees C)`='E:/gis_data/prism/gdd_mean_800m.tif',
                    `Elevation (m)`='E:/gis_data/region-2-mu-analysis/elev_30.tif',
                    `Slope Gradient (%)`='E:/gis_data/region-2-mu-analysis/slope_30.tif',
                    `Annual Beam Radiance (MJ/sq.m)`='E:/gis_data/ca630/beam_rad_sum_mj_30m.tif',
                    `(Estimated) MAST (degrees C)`='E:/gis_data/ca630/mast-model.tif',
                    `Slope Aspect (degrees)`='E:/gis_data/region-2-mu-analysis/aspect_30.tif',
                    `Geomorphon Landforms`='L:/Geodata/DEM_derived/forms10.tif',
                    `Curvature Classes`='E:/gis_data/ca630/curvature_classes_15.tif',
                    `Compound Topographic Index`='E:/gis_data/ca630/tci30.tif',
                    `MRVBF`='E:/gis_data/ca630/mrvbf_10.tif',
                    `SAGA TWI`='E:/gis_data/ca630/saga_twi_10.tif'
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
mu.set <- c('7011', '7085', '7086')



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
pts.per.acre <- 2



###########################
### quantiles of interest #
###########################
p.quantiles <- c(0.05, 0.1, 0.25, 0.5, 0.75, 0.9, 0.95)


########################################################
### correct sample size for spatial autocorrelation? ###
########################################################
correct.sample.size <- TRUE


###########################################
### save samples after report has run ? ###
###########################################
cache.samples <- TRUE

