##
## setup.R file for soilReports report
## 
## required fields: .report.name, .report.version, .report.description, .paths.to.copy (vector), .update.paths.to.copy,
## optional fields: .packages.to.get, .gh.packages.to.get, .has.shiny.interface
##

#basic report metadata
.report.name <- 'mupolygon_summary_by_project'      
.report.version <- 0.1
.report.description <- 'summarize mupolygon layer from a geodatabase'

#report manifest
.paths.to.copy <- c('report.Rmd','config.R') #on reportInit() or copyReport()
.update.paths.to.copy <- c('report.Rmd') #on reportInit(update.report=TRUE) or reportUpdate()

#OPTIONAL
.has.shiny.interface <- FALSE

## note: this will not update installed packages... could lead to dependency-related errors
## packages + deps installed from CRAN
.packages.to.get <- c("aqp","soilDB","knitr","plyr","reshape2","circular","lattice","latticeExtra","RColorBrewer","maps","maptools","mapview","soilReports","rgdal","sp","sf","raster") 

#github packages to get (via devtools::install_github)
#.gh.packages.to.get <- c('')
