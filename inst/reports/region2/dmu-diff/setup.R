##
## setup.R file for soilReports report
## 
## required fields: .report.name, .report.version, .report.description, .paths.to.copy (vector), .update.paths.to.copy,
## optional fields: .packages.to.get, .gh.packages.to.get, .has.shiny.interface
##

## note: this will not update installed packages... could lead to dependency-related errors
## packages + deps from CRAN
## version number

.report.name <- 'dmu-diff'
.report.version <- '0.5'
.report.description <- 'Differences between select DMU'

.paths.to.copy <- c('report.Rmd', 'custom.R', 'README.md', 'changes.txt', 'style.css')
.update.paths.to.copy <- c('report.Rmd', 'custom.R', 'README.md', 'changes.txt', 'style.css')

.packages.to.get <- c('knitr', 'rmarkdown', 'daff', 'soilDB')

## packages from GH, no deps
.gh.packages.to.get <- c('ncss-tech/soilDB')

# flag to indicate that shiny.Rmd and not report.Rmd is the primary markdown file; convention should probably be that shiny.Rmd has option to generate a static report.Rmd-type output. 
# currently the pedon summary demo using Shiny supports this option and uses a file called report.Rmd as the template for the static output
.has.shiny.interface <- FALSE

## fixes, usually due to an older version of R

# get an older version of knitr,  work-around, until we get R 3.3.0
# http://stackoverflow.com/questions/37241578/getting-a-parser-all-error-in-r-when-using-knitr-for-converting-a-basic-rmd-file
# .fixes <- list('install.packages("http://cran.r-project.org/src/contrib/Archive/knitr/knitr_1.12.tar.gz", repos=NULL, type="source")')
