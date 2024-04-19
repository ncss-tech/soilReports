##
## Internal setup file for report --
##   change values as needed but ensure all `.variable.names` are defined for each report
##

## packages from CRAN
.packages.to.get <- c('aqp', 'soilDB', 'sf')

## packages from GitHub, installed with no dependencies
.gh.packages.to.get <- c('ncss-tech/soilDB')

# name of report (matches parent folder name; e.g. `inst/reports/templates/minimal`)
.report.name <- 'NASIS-site-export'

# version of report
.report.version <- '1.0'

# brief description for `soilReports::listReports()`
.report.description <- 'Export NASIS Sites to Spatial Layer'

# these are the files to copy on initial installation with copyReport/reportInit
.paths.to.copy <- c('report.Rmd', 'NEWS.md')

# these are the files to copy on reportUpdate
.update.paths.to.copy <- .paths.to.copy

# this is a flag to denote whether `shiny.Rmd` is main entrypoint to report
.has.shiny.interface <- FALSE