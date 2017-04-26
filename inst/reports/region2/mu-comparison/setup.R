##
## setup file for report, be sure to use standardized variable names
##


## note: this will not update installed packages... could lead to dependency-related errors
## packages + deps from CRAN
.packages.to.get <- c('knitr', 'rmarkdown', 'rgdal', 'raster', 'plyr', 'reshape2', 'Hmisc', 'aqp', 'soilDB', 'sharpshootR', 'latticeExtra', 'clhs', 'devtools', 'rgeos', 'randomForest', 'vegan', 'spdep', 'scales')


## packages from GH, no deps
.gh.packages.to.get <- c('ncss-tech/sharpshootR')


## fixes, usually due to an older version of R

# get an older version of knitr,  work-around, until we get R 3.3.0
# http://stackoverflow.com/questions/37241578/getting-a-parser-all-error-in-r-when-using-knitr-for-converting-a-basic-rmd-file
# .fixes <- list('install.packages("http://cran.r-project.org/src/contrib/Archive/knitr/knitr_1.12.tar.gz", repos=NULL, type="source")')
