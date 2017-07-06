##
## setup.R file for soilReports report
## 
## required fields: .report.name, .report.version, .report.description, .paths.to.copy (vector), .update.paths.to.copy,
## optional fields: .packages.to.get, .gh.packages.to.get, .has.shiny.interface
##

#basic report metadata
.report.name <- 'lab_summary_by_taxonname'      
.report.version <- 1.0
.report.description <- 'summarize field pedons from NASIS pedon table'

#report manifest
.paths.to.copy <- c('report.Rmd','custom.R','genhz_rules') #on reportInit() or copyReport()
.update.paths.to.copy <- c('report.Rmd','custom.R','genhz_rules') #on reportInit(update.report=TRUE) or reportUpdate()
                          ##AB: making assumption here that you would want to update rules if you were calling update
#OPTIONAL
.has.shiny.interface <- FALSE

## note: this will not update installed packages... could lead to dependency-related errors
## packages + deps installed from CRAN
.packages.to.get <- c("aqp","soilDB","knitr","plyr","reshape2","circular","lattice","latticeExtra","RColorBrewer","maps","maptools","mapview","soilReports") 

#github packages to get (via devtools::install_github)
#.gh.packages.to.get <- c('')
