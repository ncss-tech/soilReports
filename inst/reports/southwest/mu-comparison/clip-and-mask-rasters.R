# quick clip of a named list of rasters to target area
library(terra)

USE_MASK <- TRUE
OVERWRITE <- TRUE
OUTPUT_PATH <- "data"

# read shp file containing desired extent to crop
f <- vect("data/ca630_clip.shp")

# config file contains `raster.list` -- named list of raster inputs (as in config.R)
source("config.R")

if (!dir.exists(OUTPUT_PATH)) 
  dir.create(OUTPUT_PATH, recursive = TRUE)

# iterate through raster list, transform shp to CRS of raster, and crosp
res <- lapply(as.list(unlist(raster.list)), function(r) {
  ras <- rast(r)
  levels(r) <- NULL # remove any attribute table, just raw values
  f.t <- project(f, ras)
  fname <- file.path(OUTPUT_PATH, paste0("crop_", basename(sources(ras)[1])))
  crop(ras, f.t, mask = USE_MASK, filename = fname, overwrite = OVERWRITE)
})

