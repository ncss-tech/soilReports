##
## setup file for report, be sure to use standardized variable names
##


## note: this will not update installed packages... could lead to dependency-related errors
## packages + deps from CRAN
.packages.to.get <- c('soilDB','sharpshootR','rgdal','raster','leaflet','mapview','latticeExtra','rmarkdown','plyr','reshape2','xtable','knitr','shiny','flexdashboard')


## packages from GH, no deps
.gh.packages.to.get <- c('ncss-tech/soilDB','ncss-tech/sharpshootR')

.report.name <- 'shiny-pedon-summary'
.report.version <- '0.2'
.report.description <- 'interactively subset and summarize NASIS pedon data from one or more map units'

.paths.to.copy <- c('report.Rmd','shiny.Rmd','utility_functions.R','main.R','config.R','changes.txt')
.update.paths.to.copy <- c('report.Rmd','shiny.Rmd','utility_functions.R','main.R')