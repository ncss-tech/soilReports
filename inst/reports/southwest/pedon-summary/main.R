

##
## TODO: 
## 3. use PO-logistic regression for horizon probability depth-functions
## 4. on component reports, use textural triangle density plot 
## 5. coallate TODO items from local_functions.R
## 6. generalize functions, move to sharpshootR package

## Notes:
## 1. pedons must be defined in report-rules
## 2. pedons must have WGS84 coordinates


# Load rmarkdown
library(rmarkdown)
  
## reports
setwd("C:/data")
comp <- 'Nedsgulch'
path <- 'reports/'
filename <- paste(path, comp, '.html', sep='')
save(comp, file='this.component.Rda')
render('component-report.Rmd', output_format='html_vignette', output_file=filename, quiet = TRUE, clean=TRUE)


## generate component reports, one for each with gen hz rules
source('report-rules.R')
# iterate over components with gen hz rules and make reports
for(comp in names(gen.hz.rules)) {
	filename <- paste(gsub(' ', '_', comp), '.html', sep='')
	save(comp, file='this.component.Rda')
	render('component-report.Rmd', output_format='html_vignette', output_file=filename, quiet=TRUE, clean=TRUE)
}

