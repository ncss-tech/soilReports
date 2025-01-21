##
## setup.R file for soilReports report
## 
## required fields: .report.name, .report.version, .report.description, .paths.to.copy (vector), .update.paths.to.copy,
## optional fields: .packages.to.get, .gh.packages.to.get, .has.shiny.interface
##

#basic report metadata
.report.name <- 'pedon_summary_by_taxonname'      
.report.version <- 1.1
.report.description <- 'summarize field pedons from NASIS pedon table'

#report manifest
.paths.to.copy <- c('report.Rmd','custom.R',
                    'genhz_rules/Generic_rules.R',
                    'genhz_rules/Drummer_rules.R') #on reportInit() or copyReport()
.update.paths.to.copy <- c('report.Rmd','custom.R') #on reportInit(update.report=TRUE) or reportUpdate()

#OPTIONAL
.has.shiny.interface <- FALSE

## note: this will not update installed packages... could lead to dependency-related errors
## packages + deps installed from CRAN
.packages.to.get <- c("aqp","soilDB","knitr","plyr","reshape2","circular","lattice","latticeExtra","RColorBrewer","maps","maptools","mapview","soilReports") 

#github packages to get (via remotes::install_github)
#.gh.packages.to.get <- c('')
