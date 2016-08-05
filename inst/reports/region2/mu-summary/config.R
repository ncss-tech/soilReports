### MU Summary Report for Large Collections
### 2016-07-07
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
                    `Geomorphon Landforms`='E:/gis_data/region-2-mu-analysis/forms30_region2.tif',
                    `Curvature Classes`='E:/gis_data/ca630/curvature_classes_15.tif'
)


## 
## raster data commonly used for SDJR, adjust as needed
##
# raster.list <- list(`Mean Annual Air Temperature (degrees C)`='E:/gis_data/prism/final_MAAT_800m.tif', 
#                     `Mean Annual Precipitation (mm)`='E:/gis_data/prism/final_MAP_mm_800m.tif',
#                     `Effective Precipitation (mm)`='E:/gis_data/prism/effective_precipitation_800m.tif',
#                     `Frost-Free Days`='E:/gis_data/prism/ffd_mean_800m.tif',
#                     `Growing Degree Days (degrees C)`='E:/gis_data/prism/gdd_mean_800m.tif',
#                     `Elevation (m)`='E:/gis_data/region-2-mu-analysis/elev_30.tif',
#                     `Slope Gradient (%)`='E:/gis_data/region-2-mu-analysis/slope_30.tif',
#                     `Slope Aspect (degrees)`='E:/gis_data/region-2-mu-analysis/aspect_30.tif',
#                     `Geomorphon Landforms`='E:/gis_data/region-2-mu-analysis/forms30_region2.tif',
#                     `Curvature Classes`='E:/gis_data/region-2-mu-analysis/curvature_classes_30_class_region2.tif'
# )



###################
### Map unit data #
###################

##
## Data are in a large geodatabase with many map units, explicit subsetting
##
# geodatabase path
mu.dsn <- 'E:/gis_data/ca630/FG_CA630_OFFICIAL.gdb'
# name of featureclass
mu.layer <- 'ca630_a'


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


############################################
### optional: define a subset of map units # 
############################################
mu.set <- c('5012', '7089', '7011')



#########################################################
### polygon sampling density (samples / acre / polygon) #
#########################################################

# values less < 1 (coarse sampling density) will result in variation between runs, and un-sampled polygons
# values > 10 will result in longer report run times
pts.per.acre <- 1



###########################
### quantiles of interest #
###########################
p.quantiles <- c(0.05, 0.1, 0.25, 0.5, 0.75, 0.9, 0.95)


