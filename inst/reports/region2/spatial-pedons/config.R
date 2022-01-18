# config.R for spatial-pedons
# 

# use NASIS selected set? (TRUE) or whole local database (FALSE)
SELECTED_SET = TRUE

# path to spatial datasource name (a folder or geodatabase)
SPATIAL_DSN = "SSURGO" # either "SSURGO", "STATSGO" or path to shapefile/File Geodatabase
                       # Shapefile/feature class should contain attributes: "AREASYMBOL", "MUSYM"
# spatial layer 
SPATIAL_LAYER = NULL # NULL/ignored for SPATIAL_DSN = "SSURGO" or "STATSGO"
                     # Shapefile name without .SHP extension (if SPATIAL_DSN is a folder)
                     # Feature class name in File Geodatabase (if SPATIAL_DSN is a .gdb)

# thematic column name for horizon colors in SoilProfileCollection plots
HORIZON_THEME <- "moist_soil_color" # "dry_soil_color", "clay", etc.

# a file path to Rda. or NULL for caching pedon data
PEDON_CACHE = NULL #"cache.Rda" 