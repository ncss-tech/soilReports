##
## setup file for report, be sure to use standardized variable names
##

## packages + deps from CRAN
.packages.to.get <- c('rgdal', 'aqp', 'soilDB', 'shiny', 'flexdashboard', 'leaflet', 'mapview')

## packages from GH, no deps
.gh.packages.to.get <- c('ncss-tech/aqp','ncss-tech/soilDB','ncss-tech/sharpshootR')

.report.name <- 'mu-comparison-dashboard'
.report.version <- '0.0.0'
.report.description <- 'interactively subset and summarize SSURGO data for input to `region2/mu-comparison` report'

.paths.to.copy <- c('shiny.Rmd','default_config.R','changes.txt') #report.Rmd
.update.paths.to.copy <- c('shiny.Rmd','changes.txt')