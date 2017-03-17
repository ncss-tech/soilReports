##
## setup file for report, be sure to use standardized variable names
##


## note: this will not update installed packages... could lead to dependency-related errors
## packages + deps from CRAN
.packages.to.get <- c('knitr', 'rmarkdown', 'plyr', 'reshape2', 'clhs', 'devtools', 'randomForest', 'vegan')


## packages from GH, no deps
.gh.packages.to.get <- c()


## fixes, usually due to an older version of R
