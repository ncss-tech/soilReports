## PACKAGES
## 
##  Data
library(elevatr)
library(soilDB)

##  Spatial
library(sf)
library(raster)

##  Graphics
library(png)
library(rayshader)
library(rgl)
# library(rasterVis)

### OPTIONS

## DATA SOURCES

# use soilDB::mukey.wcs for thematic raster (values: MUKEY integers)
use_ssurgo <- TRUE

target_crs <- "EPSG:6350"
target_resolution <- 5 # meters

# if FALSE, specify custom name and path to thematic raster
thematic_raster_path <- NA
label_table <- NA

# use elevatr to get DEM data
use_elevatr <- TRUE
elevatr_zoom <- 14

## SHADOWS?
add_amb_shadows <- TRUE
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

## POINT LOCATION
a_point <- st_as_sf(data.frame(y = 37.97892788288914, 
                               x = -120.27964390945054),
                    coords = c("x", "y"),
                    crs = st_crs(4326))

# get the data
dem_orig <- elevatr::get_elev_raster(a_point, z = elevatr_zoom)
dem <- projectRaster(dem_orig, 
                     res = c(target_resolution, target_resolution),
                     crs = CRS(target_crs))
ssurgo_mukey <- soilDB::mukey.wcs(st_bbox(extent(dem), crs = st_crs(dem)))

# reproject theme raster to match dem raster
theme <- suppressWarnings(projectRaster(ssurgo_mukey, dem, method = "ngb"))

# ratify theme raster
theme <- raster::ratify(theme)
rat <- levels(theme)[[1]]

if (use_ssurgo) {
  ukeys <- unique(values(ssurgo_mukey))
  label_table <- data.frame(ID = ukeys, 
                            Label = as.character(1:length(ukeys)), 
                            Color = viridis::viridis(length(ukeys)))
} 
idname <- "ID"

# LEFT JOIN on ID
if (exists("label_table") && !is.na(label_table)) {
  
  if (!all(c("ID","Label","Color") %in% colnames(label_table)))
    stop("Raster thematic attribute `label_table` should contain `ID`, `Label` and `Color`", call. = FALSE)
  
  rat <- merge(rat, 
               label_table, 
               by.x = idname, 
               by.y = "ID", 
               all.x = TRUE, 
               sort = FALSE,
               incomparables = NA)
  
  levels(theme) <- rat
}

# CHECK: Plot rasterized soil layer and extent
# rasterVis::levelplot(theme, att="ID")

# function to create a thematic PNG to create a rayshader-friendly color array
make_conformal_theme <- function(elmat, theme) {
  tf <- tempfile()
  .fliplr <- function(x) { x[,ncol(x):1] }
  png(tf, width = nrow(elmat), height = ncol(elmat))
    par(mar = c(0,0,0,0))
    raster::image(.fliplr(rayshader::raster_to_matrix(theme)), 
                  axes = FALSE, 
                  col = viridis::viridis(length(unique(values(theme)))))
  dev.off()
  png::readPNG(tf)
}

custom_rgb_theme <- function(theme, label_table) {
  
  # PROCESSING: create RGB array from rasterized theme
  lut <- data.frame(.idx = 1:nrow(label_table), 
                    Color = label_table$Color, 
                    t(col2rgb(label_table$Color, alpha = TRUE) / 255))
  
  idlut <- lut$.idx
  names(idlut) <- label_table$ID
  
  intid <- as.numeric(idlut[as.character(values(theme))])
  
  lutc <- lut[intid,]
  
  theme$r <- lutc$red
  theme$b <- lutc$blue
  theme$g <- lutc$green
  theme$a <- lutc$alpha
  
  redmat <- rayshader::raster_to_matrix(theme$r)
  grnmat <- rayshader::raster_to_matrix(theme$g)
  blumat <- rayshader::raster_to_matrix(theme$b)
  alpmat <- rayshader::raster_to_matrix(theme$a)
  
  my.array <- array(1, c(nrow(redmat), ncol(redmat), 4))
  my.array[,,1] <- redmat
  my.array[,,2] <- grnmat
  my.array[,,3] <- blumat
  
  # NOTE: alpha layer dropped
  
  # PROCESSING: Re-arrange array for rayshader
  aperm(my.array, c(2,1,3))
}

theme_array <- custom_rgb_theme(theme, label_table)

# make the theme raster align with dem array
# theme_array <- make_conformal_theme(elmat = rayshader::raster_to_matrix(dem),
#                                     theme = theme)

elmat <- rayshader::raster_to_matrix(dem)

# calculate a rayshader "scene"
a_scene <- elmat %>%
  sphere_shade(texture = "desert") %>%
  # add_overlay(height_shade(elmat)) %>%
  add_overlay(theme_array) 

# if add_ray_shadows parameter is set to TRUE, calculate ray shading 
if (add_ray_shadows) {
  a_scene <- a_scene %>%
    add_shadow(ray_shade(elmat), max_darken = 0.4) 
}

# and for add_amb_shadows ambient shading
if (add_amb_shadows) {
  a_scene <- a_scene %>%
    add_shadow(ambient_shade(elmat), max_darken = 0.3) 
}

# calculate an appropriate plot_3d zscale value
estimate_zscale <- function(elmat, dem, zfactor = pi) {
  x <- as.numeric(st_bbox(dem))
  (data.frame(
    dx = x[3] - x[1],
    dy = x[4] - x[2],
    dz = max(values(dem), na.rm=T) - min(values(dem), na.rm=T),
    sx = ncol(elmat),
    sy = nrow(elmat)
  ) %>%
    transform(xratio = dx / sx, 
              yratio = dy / sy) %>%
    transform(zratio = mean(c(xratio, yratio)) / zfactor))
}

rgl::rgl.clear()
estz <- estimate_zscale(elmat, dem)

plot_3d(
  a_scene,
  elmat,
  fov = 0,
  theta = 30,
  water = 0,
  zscale = estz$zratio,
  zoom = 0.75,
  phi = 45,
  windowsize = c(1000, 800),
  lineantialias = TRUE
)

# unfortunately this errors when !is.null(text) on our Windows build of rgl
# Error in rgl.texts(x = -318.573411745982, y = 1094.31292724609, z = -226.439309594939,  : 
# FreeType not supported in this build
# suppressWarnings(render_label(
#   elmat,
#   text = NULL,
#   lat = 37.97892788288914,
#   long = -120.27964390945054,
#   extent = raster::extent(dem),
#   altitude = 250
# ))
