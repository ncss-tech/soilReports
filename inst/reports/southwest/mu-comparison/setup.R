##
## setup.R file for soilReports report
## 
## required fields: .report.name, .report.version, .report.description, .paths.to.copy (vector), .update.paths.to.copy,
## optional fields: .packages.to.get, .gh.packages.to.get, .has.shiny.interface
##

## note: this will not update installed packages... could lead to dependency-related errors
## packages + deps from CRAN
## version number

.report.name <- 'mu-comparison'
.report.version <- '4.1.5'
.report.description <- 'compare stack of raster data, sampled from polygons associated with 1-8 map units'

.paths.to.copy <-
  c(
    'report.Rmd',
    'custom.R',
    'config.R',
    'categorical_definitions.R',
    'README.md',
    'changes.txt',
    'create-NASIS-import-files.R',
    'clip-and-mask-rasters.R'
  )

.update.paths.to.copy <-
  c(
    'report.Rmd',
    'custom.R',
    'categorical_definitions.R',
    'README.md',
    'changes.txt',
    'create-NASIS-import-files.R',
    'clip-and-mask-rasters.R'
  )


.packages.to.get <-
  c(
    'knitr',
    'rmarkdown',
    "MASS",
    "sf",
    "mapview",
    "terra",
    "data.table",
    "latticeExtra",
    "cluster",
    "clhs",
    "randomForest",
    "aqp",
    "sharpshootR",
    "RColorBrewer",
    "spdep"
  )

## packages from GH
# dependencies should be satisfied by installing CRAN version first
.gh.packages.to.get <- c(
  'ncss-tech/sharpshootR', 
  'ncss-tech/soilDB', 
  'ncss-tech/aqp'
)

# flag to indicate that shiny.Rmd and not report.Rmd is the primary markdown file; convention should probably be that shiny.Rmd has option to generate a static report.Rmd-type output. 
# currently the pedon summary demo using Shiny supports this option and uses a file called report.Rmd as the template for the static output
.has.shiny.interface <- FALSE
