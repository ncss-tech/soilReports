##
## Internal setup file for report -- 
##   change values as needed but ensure all `.variable.names` are defined for each report
##

## packages from CRAN
.packages.to.get <- c()

## packages from GitHub, installed with no dependencies
.gh.packages.to.get <- c()

# name of report (matches parent folder name; e.g. `inst/reports/templates/minimal`)
.report.name <- 'DT-report'

# version of report
.report.version <- '1.0'

# brief description for `soilReports::listReports()`
.report.description <- 'Create interactive data tables from CSV files'

# these are the files to copy on initial installation with copyReport/reportInit
.paths.to.copy <- c('report.Rmd','config.R','NEWS.md')

# these are the files to copy on reportUpdate
.update.paths.to.copy <- c('report.Rmd','NEWS.md')

# this is a flag to denote whether `shiny.Rmd` is main entrypoint to report
.has.shiny.interface <- FALSE