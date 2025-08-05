##
## Internal setup file for report -- 
##   change values as needed but ensure all `.variable.names` are defined for each report
##

## packages from CRAN
.packages.to.get <- c('terra', 'sf', 'exactextractr')

## packages from GitHub, installed with no dependencies
.gh.packages.to.get <- c()

# name of report (matches parent folder name; e.g. `inst/reports/templates/minimal`)
.report.name <- 'zonal-statistics'

# version of report
.report.version <- '0.1'

# brief description for `soilReports::listReports()`
.report.description <- 'Calculate zonal statistics for raster data, using polygons and unique symbols as zones'

# these are the files to copy on initial installation with copyReport/reportInit
.paths.to.copy <- c('report.Rmd', 'config.R', 'raster-data.csv', 'NEWS.md')

# these are the files to copy on reportUpdate
.update.paths.to.copy <- c('report.Rmd', 'NEWS.md')

# this is a flag to denote whether `shiny.Rmd` is main entrypoint to report
.has.shiny.interface <- FALSE