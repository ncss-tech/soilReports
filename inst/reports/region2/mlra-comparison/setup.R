##
## setup file for report, be sure to use standardized variable names
##


## note: this will not update installed packages... could lead to dependency-related errors
## packages + deps from CRAN
.packages.to.get <- c('knitr', 'rmarkdown', 'plyr', 'reshape2', 'clhs', 'devtools', 'randomForest', 'vegan')


## packages from GH, no deps
.gh.packages.to.get <- c()

## report name
.report.name <- 'mlra-comparison'
## version number
.report.version <- '0.4'
## short description
.report.description <- 'compare MLRA using pre-made, raster sample databases'

.files.to.copy <- c('report.Rmd','config.R','NOTES.md','changes.txt')
.update.files.to.copy <- c('report.Rmd','NOTES.md','changes.txt')
.has.shiny.interface <- FALSE



## fixes, usually due to an older version of R

