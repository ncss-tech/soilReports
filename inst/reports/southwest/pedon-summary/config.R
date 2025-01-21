## this is where you define input data sources

## determine subsetting rule:
## pattern: matching based on the component name 
## pedon.id.list: matching based on list of pedon IDs 
## musym: matching based on mapunit symbol
## musymtaxon: match based on taxon name, taxon kind and mapunit symbol
SUBSET_RULE <- 'musymtaxon' 
## subset.rule <- 'pedon.id.list'

# Target Mapunit Symbol (regular expression)
MUSYM_PATTERN <- '.'
TAXONNAME_PATTERN <- '.'
TAXONKIND_PATTERN <- '.'

# use NASIS selected set? (TRUE) or whole local database (FALSE)
SELECTED_SET <- TRUE

# Generalized Horizon Label rules file
GENHZ_RULES <- "genhz-rules.R"

# path to spatial datasource name (a folder or geodatabase)
SPATIAL_DSN <- "SSURGO" # either "SSURGO", "STATSGO" or path to shapefile/File Geodatabase
# Shapefile/feature class should contain attributes: "AREASYMBOL", "MUSYM"
# spatial layer 

# spatial layer within SPATIAL_DSN
SPATIAL_LAYER <- NULL # NULL/ignored for SPATIAL_DSN = "SSURGO" or "STATSGO"
# Shapefile name without .SHP extension (if SPATIAL_DSN is a folder)
# Feature class name in File Geodatabase (if SPATIAL_DSN is a .gdb)
# use "sapolygon" for soil survey area polygons

# # define raster variable names and data sources in a list
# # prefix variable names with gis_
# # need not share the same CRS
RASTER_LIST <- list(
  gis_ppt = 'F:/Geodata/project_data/MUSUM_Prism/final_MAP_mm_800m.tif',
  gis_tavg = 'F:/Geodata/project_data/MUSUM_Prism/final_MAAT_800m.tif',
  gis_ffd = 'F:/Geodata/project_data/MUSUM_Prism/ffd_50_pct_800m.tif',
  gis_gdd = 'F:/Geodata/project_data/MUSUM_Prism/gdd_mean_800m.tif'#,
  # gis_elev = 'F:/Geodata/project_data/MUSum_30m_SSR2/DEM_30m_SSR2.tif',
  # gis_solar = 'F:/Geodata/project_data/ssro2_ann_beam_rad_int.tif',
  # gis_twi = 'F:/Geodata/project_data/ssro2_saga_twi_int.tif',
  # gis_slope = 'F:/Geodata/project_data/MUSum_30m_SSR2/Slope_30m_SSR2.tif',
  # gis_geomorphons = 'F:/Geodata/project_data/MUSUM_Geomorphon/forms30_region2.tif'
)

## report details:
# probabilities for low-rv-high calculations
p.low.rv.high <- c(0.05, 0.5, 0.95)

# quantile type
q.type <- 7

# ML profile smoothing
ml.profile.smoothing <- 0.65

