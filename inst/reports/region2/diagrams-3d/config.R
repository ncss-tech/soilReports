# config.R for diagram-3d example

### OPTIONS

## DATA SOURCES

## POINT LOCATION
a_point <- st_as_sf(data.frame(y = 37.97892788288914, 
                               x = -120.27964390945054),
                    coords = c("x", "y"),
                    crs = st_crs(4326))

# use soilDB::mukey.wcs for thematic raster (values: MUKEY integers)
use_ssurgo <- TRUE

target_crs <- "EPSG:6350"
target_resolution <- 30 # meters

# if FALSE, specify custom name and path to thematic raster
thematic_raster_path <- NA
label_table <- NA

# use elevatr to get DEM data
use_elevatr <- TRUE
elevatr_zoom <- 14

## SHADOWS?
add_amb_shadows <- FALSE
add_ray_shadows <- FALSE

## EXPLANATION
##  Required fields: ID, Label, Color 
#   - _ID_: numeric value stored in the thematic raster (e.g. MUKEY)
#   - _Label_: character string label you want to show on final legend
#   - _Color_: hexadecimal representation of sRGB color to use on map and legend
#  
# Here we `read.table(text="...")`, but you could also store this in CSV files or similar
# 
# Note that for `read.table` we need to wrap the character strings in _single_ quotes.
# For instance, in a raster with integer values between `1:8` with geomorphic labels:
# 
# ```r
# label_table <- read.table(text = "ID	Label	Color
#                                   1	'Streams' '#005ce6'
#                                   2	'Minor Stream/Local Depressions'  '#73dfff'
#                                   3	'Backslope'	'#ffaa00'
#                                   4	'Stream Terraces' '#ffffbe'
#                                   5	'Plains'	'#38a800'
#                                   6	'Stream Banks'	'#737300'
#                                   7	'Local Mounds'	'#e60000'
#                                   8	'Ridges'	'#730000'", header = TRUE)
# ```
