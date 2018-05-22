library(rmarkdown)

# project name
p <- 'MLRA 17/14 - Sycamore silty clay loam'

# output directory
d <- '../2-CHI/FY2018/Sycamore/Sycamore silty clay loam/'

## notes:
# reports are stored in the same parent folder as this script
# envir = new.env() ensures that the current environment isn't polluted with objects used in reports

render(input = 'DMU-diff/report.Rmd',
       output_dir = d, 
       output_file = 'DMU-diff.html',
       params = list(projectname=p), 
       clean = TRUE,
       envir = new.env()
      )



render(input = 'QA-summary/report.Rmd',
       output_dir = d, 
       output_file = 'QA-summary.html',
       params = list(projectname=p), runtime = 'static', 
       clean = TRUE,
       envir = new.env()
)

