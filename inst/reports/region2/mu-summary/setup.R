##
## setup.R file for soilReports report
## 
## required fields: .report.name, .report.version, .report.description, .paths.to.copy (vector), .update.paths.to.copy,
## optional fields: .packages.to.get, .gh.packages.to.get, .has.shiny.interface
## 
## 
.report.name <- 'mu-summary'
.report.version <- 1.0
.report.description <- 'summarize raster data for a large collection of map unit polygons'
.paths.to.copy <- c('report.Rmd','generate-samples.R','make-reports.R','config.R','NOTES.md')
.update.paths.to.copy <- c('report.Rmd','generate-samples.R','make-reports.R','NOTES.md')
.has.shiny.interface <- FALSE

# packages + deps from CRAN
packages.to.get <- c('rmarkdown', 'rgdal', 'raster', 'plyr', 'reshape2', 'aqp', 'soilDB', 'sharpshootR', 'latticeExtra', 'clhs', 'devtools','RColorBrewer')
gh.packages.to.get <- c("ncss-tech/aqp","ncss-tech/soilDB","ncss-tech/sharpshootR")
