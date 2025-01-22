##
## setup file for report, be sure to use standardized variable names
##

## note: this will not update installed packages... could lead to dependency-related errors
## packages + deps from CRAN
.packages.to.get <- c(
  'aqp',
  'soilDB',
  'sharpshootR',
  'sf',
  'terra',
  'leaflet',
  'mapview',
  'leafem',
  'latticeExtra',
  'rmarkdown',
  'plyr',
  'reshape2',
  'xtable',
  'knitr',
  'shiny',
  'flexdashboard',
  'DT'
)

## packages from GH, no deps
.gh.packages.to.get <- c(
  'ncss-tech/aqp',
  'ncss-tech/soilDB',
  'ncss-tech/sharpshootR'
)

.report.name <- 'shiny-pedon-summary'
.report.version <- '1.2'
.report.description <- 'Interactively subset and summarize NASIS pedon data from one or more map units'

.paths.to.copy <- c(
  'report.Rmd',
  'shiny.Rmd',
  'util.R',
  'config.R',
  'packages.R',
  'changes.txt'
)

.update.paths.to.copy <- c('report.Rmd', 
                           'shiny.Rmd', 
                           'util.R', 
                           'packages.R')

.has.shiny.interface <- TRUE