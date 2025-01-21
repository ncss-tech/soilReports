##
## setup.R file for soilReports report
## 
## required fields: .report.name, .report.version, .report.description, .paths.to.copy (vector), .update.paths.to.copy,
## optional fields: .packages.to.get, .gh.packages.to.get, .has.shiny.interface
##

## note: this will not update installed packages... could lead to dependency-related errors
## packages + deps from CRAN
## version number

.report.name <- 'pedon-summary'
.report.version <- '1.0'
.report.description <- 'Generate summaries from NASIS pedons and associated spatial data'

.paths.to.copy <- c('report.Rmd', 'custom.R', 'config.R', 'genhz-rules.R', 'README.md', 'changes.txt')
.update.paths.to.copy <- c('report.Rmd','custom.R', 'genhz-rules.R', 'README.md', 'changes.txt')
.packages.to.get <- c('knitr', 'rmarkdown', 'soilDB', 'reshape2', 'plyr', 'xtable', 'Hmisc', 'aqp', 'latticeExtra', 'sharpshootR', 'gridExtra', 'MASS', 'devtools', 'sf', 'terra')

## packages from GH
# dependencies should be satisfied by installing CRAN version first
.gh.packages.to.get <- c('ncss-tech/aqp', 'ncss-tech/soilDB', 'ncss-tech/sharpshootR')

# flag to indicate that shiny.Rmd and not report.Rmd is the primary markdown file; convention should probably be that shiny.Rmd has option to generate a static report.Rmd-type output. 
# currently the pedon summary demo using Shiny supports this option and uses a file called report.Rmd as the template for the static output
.has.shiny.interface <- FALSE