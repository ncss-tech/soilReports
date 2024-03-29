##
## setup.R file for soilReports report
## 
## required fields: .report.name, .report.version, .report.description, .paths.to.copy (vector), .update.paths.to.copy,
## optional fields: .packages.to.get, .gh.packages.to.get, .has.shiny.interface
##

## note: this will not update installed packages... could lead to dependency-related errors
## packages + deps from CRAN
.packages.to.get <- c('knitr', 'rmarkdown', 'plyr', 'reshape2', 'clhs', 'devtools', 'randomForest', 'vegan', 'ggplot2', 'kableExtra', 'RColorBrewer')


## packages from GH, no deps
.gh.packages.to.get <- c()

## report name
.report.name <- 'mlra-comparison'

## version number
.report.version <- '2.0'

## short description
.report.description <- 'compare MLRA using pre-made, raster sample databases'

.paths.to.copy <- c('report.Rmd', 'custom.R', 'config.R', 'README.md', 'changes.txt')
.update.paths.to.copy <- c('report.Rmd', 'custom.R', 'README.md','changes.txt')

.has.shiny.interface <- FALSE


## fixes, usually due to an older version of R

