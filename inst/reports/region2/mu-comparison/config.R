### MU GIS Summary Report
### 2016-07-22
### D.E. Beaudette and J. Wood
###
### configuration file, edit as needed


#########################
### Raster Data Sources #
#########################


## raster data commonly used for SDJR, adjust as needed
##
raster.list <- list(`Mean Annual Air Temperature (degrees C)`='Y:/geodata/project_data/MUSum_PRISM/final_MAAT_800m.tif', 
                    `Mean Annual Precipitation (mm)`='Y:/geodata/project_data/MUSum_PRISM/final_MAP_mm_800m.tif',
                    `Effective Precipitation (mm)`='Y:/geodata/project_data/MUSum_PRISM/effective_precipitation_800m.tif',
                    `Frost-Free Days`='Y:/geodata/project_data/MUSum_PRISM/ffd_mean_800m.tif',
                    `Growing Degree Days (degrees C)`='Y:/geodata/project_data/MUSum_PRISM/gdd_mean_800m.tif',
                    `Elevation (m)`='Y:/geodata/project_data/MUSum_10m_MLRA/DEM_KLM_int_AEA.tif',
                    `Slope Gradient (%)`='Y:/geodata/project_data/MUSum_10m_MLRA/Slope_KLM_int_AEA.tif',
                    `Slope Aspect (degrees)`='Y:/geodata/project_data/MUSum_10m_MLRA/Aspect_KLM_int_AEA.tif',
                    `Geomorphon Landforms`='Y:/geodata/project_data/MUSum_Geomorphon/forms30_region2.tif',
                    `Curvature Classes`='Y:/geodata/project_data/MUSum_Curvature/curvature_classes_30_class_region2.tif'
)

# 
## raster data used for CA630, adjust as needed
##
##raster.list <- list(`Mean Annual Air Temperature (degrees C)`='E:/gis_data/prism/final_MAAT_800m.tif', 
#                     `Mean Annual Precipitation (mm)`='E:/gis_data/prism/final_MAP_mm_800m.tif',
#                     `Effective Precipitation (mm)`='E:/gis_data/prism/effective_precipitation_800m.tif',
#                     `Frost-Free Days`='E:/gis_data/prism/ffd_mean_800m.tif',
#                     `Growing Degree Days (degrees C)`='E:/gis_data/prism/gdd_mean_800m.tif',
#                     `Elevation (m)`='E:/gis_data/region-2-mu-analysis/elev_30.tif',
#                     `Slope Gradient (%)`='E:/gis_data/region-2-mu-analysis/slope_30.tif',
#                     `Annual Beam Radiance (MJ/sq.m)`='E:/gis_data/ca630/beam_rad_sum_mj_30m.tif',
#                     `(Estimated) MAST (degrees C)`='E:/gis_data/ca630/mast-model.tif',
#                     `Slope Aspect (degrees)`='E:/gis_data/region-2-mu-analysis/aspect_30.tif',
#                     `Geomorphon Landforms`='E:/gis_data/region-2-mu-analysis/forms30_region2.tif',
#                     `Curvature Classes`='E:/gis_data/ca630/curvature_classes_15.tif'
# )

###################
### Map unit data #
###################

# ##
# ## Typical SDJR style data: Shape file with multiple map units
# ##
# # path to shape file
mu.dsn <- 'E:/Workspace/Project_Folder/MUSum'
# # SHP name, without file extension
mu.layer <- 'MUs_for_analysis'


##
## Data are in a large geodatabase with many map units, explicit subsetting
##
# geodatabase path
# mu.dsn <- 'E:/gis_data/ca630/FG_CA630_OFFICIAL.gdb'
# name of featureclass
# mu.layer <- 'ca630_a'
# map unit symbols / keys to extract
# mu.set <- c('5012', '5015', '5201', '7085', '7089', '7011')



############################################
### column with map unit ID / key / symbol #
############################################
mu.col <- 'MUSYM'


#########################################################
### polygon sampling density (samples / acre / polygon) #
#########################################################

# values less < 1 (coarse sampling density) will result in variation between runs, and un-sampled polygons
# values > 10 will result in longer report run times
pts.per.acre <- 5



###########################
### quantiles of interest #
###########################
p.quantiles <- c(0.05, 0.1, 0.25, 0.5, 0.75, 0.9, 0.95)


