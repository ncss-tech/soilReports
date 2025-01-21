## more efficient approach
# 1. sample all map units
# 2. generate reports from cached samples

library(rmarkdown)

# generate samples
# source('generate-samples.R')

# load cached samples
# efficient loading on-demand: http://stackoverflow.com/questions/8700619/get-specific-object-from-rdata-file
load('cached-samples.Rda')

# make an output dir if it doesn't exist
if(!dir.exists('HTML-reports')) dir.create('./HTML-reports')

# iterate over map units
for(this.mu in mu.set) {
  
  # filter samples and save
  d.mu.filtered <- d.mu[which(d.mu$.id == this.mu), ]
  mu.area.filtered <- mu.area[which(mu.area$.id == this.mu), ]
  save(d.mu.filtered, mu.area.filtered, file='filtered-samples.Rda')
  
  # HTML output
  filename <- paste('HTML-reports/', this.mu, '_summary.html', sep='')
  render('GIS-summary-all-MU.Rmd', output_format='html_vignette', output_file=filename, quiet=TRUE, clean=TRUE)
}
