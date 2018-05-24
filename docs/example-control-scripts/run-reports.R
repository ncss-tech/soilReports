library(rmarkdown)


## optionally export latest templates

# library(soilReports)
# reportInit(reportName = 'region2/dmu-diff', outputDir = 'DMU-diff', overwrite = FALSE)
# reportInit(reportName = 'region2/QA-summary', outputDir = 'QA-summary', overwrite = FALSE)

## configuration:
# these reports get their configuration from the local NASIS DB: load a single project and associated DMU.

# output directory
d <- '../2-CHI/FY2018/Sycamore/Sycamore silty clay loam/'

## notes:
# reports are stored in the same parent folder as this script
# envir = new.env() ensures that the current environment isn't polluted with objects used in reports

render(input = 'DMU-diff/report.Rmd',
       output_dir = d, 
       output_file = 'DMU-diff.html',
       clean = TRUE,
       envir = new.env()
      )



render(input = 'QA-summary/report.Rmd',
       output_dir = d, 
       output_file = 'QA-summary.html',
       clean = TRUE,
       envir = new.env()
)

