##
## setup.R file for soilReports report
## 
## required fields: .report.name, .report.version, .report.description, .paths.to.copy (vector), .update.paths.to.copy,
## optional fields: .packages.to.get, .gh.packages.to.get, .has.shiny.interface
##

#basic report metadata
.report.name <- 'component_summary_by_project'      
.report.version <- '0.1'
.report.description <- 'summarize component data for an MLRA project'

#report manifest
.paths.to.copy <- c('report.Rmd') #on reportInit() or copyReport()
.update.paths.to.copy <- c('report.Rmd')     #on reportInit(update.report=TRUE) or reportUpdate()

#OPTIONAL
.has.shiny.interface <- FALSE

## note: this will not update installed packages... could lead to dependency-related errors
## packages + deps installed from CRAN
.packages.to.get <- c('knitr', 'ggplot2', 'soilDB') #, 'soilReports') # ? 

#github packages to get (via devtools::install_github)
#.gh.packages.to.get <- c('')
