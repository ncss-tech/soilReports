##
## Internal setup file for report -- 
##   change values as needed but ensure all `.variable.names` are defined for each report
##

## packages from CRAN
.packages.to.get <- c('aqp', 'soilDB', 'sf', 'mapview', 'data.table', 'knitr', 'rmarkdown')

## packages from GitHub, installed with no dependencies
.gh.packages.to.get <- c('ncss-tech/aqp','ncss-tech/soilDB')

# name of report (matches parent folder name; e.g. `inst/reports/templates/minimal`)
.report.name <- 'EDITSoilFeatures'

# version of report
.report.version <- '0.2.1'

# brief description for `soilReports::listReports()`
.report.description <- 'Generate summaries of NASIS components for EDIT Soil Features sections'

# these are the files to copy on initial installation with copyReport/reportInit
.paths.to.copy <- c('report.Rmd', 'batch.Rmd', "utils.R", 'NEWS.md', 'README.md')

# these are the files to copy on reportUpdate
.update.paths.to.copy <- c('report.Rmd', 'batch.Rmd', "utils.R", 'NEWS.md', 'README.md')

# this is a flag to denote whether `shiny.Rmd` is main entrypoint to report
.has.shiny.interface <- FALSE
