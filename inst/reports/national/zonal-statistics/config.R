# config.R

# path to polygon source
#  could be e.g. parent folder of SHP, or path to file geodatabase or geopackage
MU_DSN <- 'D:/RGISS/S26_SWFS_LTSD.gdb'

# layer name (without file extension)
MU_LAYER <- 'MUPOLYGON'

# could be 'MUKEY', 'MUSYM', or any column name in MU_LAYER
MU_COL <- 'MUSYM'

# symbols of interest (used to subset MU_LAYER using MU_COL)
MU_SET <- c("201", "205", "212", "213")

# raster data (path to CSV file that contains columns: variable, path and digits)
RASTER_DATA_FILE <- "raster-data.csv"

# aggregation methods (see ?exactextractr::exact_extract for details)
# FUN <- c("mean", "stdev")
# FUN <- "quantile"
FUN <- c("mean", "stdev", "min", "quantile", "max")

# aggregation additional arguments
ARGS <- list(quantiles = c(0.1, 0.5, 0.9))

# apply aggregation to each polygon (TRUE) or each mu.col group (FALSE)?
BY_POLYGON <- FALSE

# default output directory and file name
OUTPUT_DIR <- "output"
OUTPUT_BASENAME <- paste0("zonal-stats-", MU_LAYER, "-", MU_COL, "-", as.numeric(Sys.time()))
OUTPUT_REPORT_NAME <- paste0(OUTPUT_BASENAME, ".html")
