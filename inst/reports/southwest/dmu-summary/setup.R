##
## Internal setup file for report -- 
##   change values as needed but ensure all `.variable.names` are defined for each report
##

## packages from CRAN
.packages.to.get <- c('aqp','soilDB','sharpshootR','latticeExtra','reshape2','tactile','kableExtra','ggplot2')

## packages from GitHub, installed with no dependencies
.gh.packages.to.get <- c('ncss-tech/aqp','ncss-tech/soilDB','ncss-tech/sharpshootR')

# name of report (matches parent folder name; e.g. `inst/reports/templates/minimal`)
.report.name <- 'DMU-summary'

# version of report
.report.version <- '0.5'

# brief description for `soilReports::listReports()`
.report.description <- 'DMU Summary Report'

# these are the files to copy on initial installation with copyReport/reportInit
.paths.to.copy <- c('report.Rmd', 'custom.R', 'cache-data.R', 'config.R')

# these are the files to copy on reportUpdate
.update.paths.to.copy <- c('report.Rmd', 'custom.R', 'cache-data.R')

# this is a flag to denote whether `shiny.Rmd` is main entry point to report
.has.shiny.interface <- FALSE
