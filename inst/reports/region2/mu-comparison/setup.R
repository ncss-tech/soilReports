## you need all of these packages to run the report

## get an older version of knitr
## work-around, until we get R 3.3.0
# http://stackoverflow.com/questions/37241578/getting-a-parser-all-error-in-r-when-using-knitr-for-converting-a-basic-rmd-file
packageurl <- "http://cran.r-project.org/src/contrib/Archive/knitr/knitr_1.12.tar.gz"
install.packages(packageurl, repos=NULL, type="source")

# packages + deps from CRAN
packages.to.get <- c('rmarkdown', 'rgdal', 'raster', 'plyr', 'reshape2', 'aqp', 'soilDB', 'sharpshootR', 'latticeExtra', 'clhs', 'devtools')
res <- sapply(packages.to.get, install.packages, dep=TRUE)

# latest versions from GitHub
devtools::install_github("ncss-tech/aqp", dependencies=FALSE, upgrade_dependencies=FALSE)
devtools::install_github("ncss-tech/soilDB", dependencies=FALSE, upgrade_dependencies=FALSE)
devtools::install_github("ncss-tech/sharpshootR", dependencies=FALSE, upgrade_dependencies=FALSE)

