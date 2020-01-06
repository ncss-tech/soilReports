## this is where you define input data sources


## determine subsetting rule:
## pattern: matching based on the component name specified in report-rules.R
## pedon.id.list: matching based on list of pedon IDs specified in report-rules.R
subset.rule <- 'musymtaxon'
## subset.rule <- 'pedon.id.list'

## report details:
# probabilities for low-rv-high calculations
p.low.rv.high <- c(0.05, 0.5, 0.95)

# quantile type
q.type <- 7

# ML profile smoothing
ml.profile.smoothing <- 0.65

## GIS data details
# map unit linework 
mu.dsn <- 'L:/NRCS/MLRAShared/CA792/ca792_spatial/FG_CA792_OFFICIAL.gdb'
mu.layer <- 'ca792_a'
mu.sym <- '.'

# define raster variable names and data sources, store in a list
# prefix variable names with gis_
# these should all share the same CRS
r <- list(
  gis_ppt=raster('C:/workspace/R_reports/Geodata/climate/final_MAP_mm_800m.tif'),
  gis_tavg=raster('C:/workspace/R_reports/Geodata/climate/final_MAAT_800m.tif'),
  gis_ffd=raster('C:/workspace/R_reports/Geodata/climate/ffd_mean_800m.tif'),
  gis_gdd=raster('C:/workspace/R_reports/Geodata/climate/gdd_mean_800m.tif'),
  gis_elev=raster('C:/workspace/R_reports/Geodata/elev10.tif'),
  gis_solar=raster('C:/workspace/R_reports/Geodata/ssro2_ann_beam_rad_int.tif'),
  gis_slope=raster('C:/workspace/R_reports/Geodata/MUSum_10m_SSR2/SSR2_Slope10m_AEA.tif'),
  gis_geomorphons=raster('C:/workspace/R_reports/Geodata/MUSum_Geomorphon/forms10_region2.tif')
)

## map unit data: load the official version
mu <-  readOGR(dsn=mu.dsn, layer=mu.layer, encoding='encoding', stringsAsFactors=FALSE)

# convert: character -> integer -> character
# drops all bogus or undefined map units

mu$MUSYM <- as.character(mu$MUSYM)
#(as.integer(as.character(mu$MUSYM)))


#as.character(as.integer(as.character("6074b"))

