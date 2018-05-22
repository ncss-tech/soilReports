library(rmarkdown)

# project name
p <- 'MLRA 17 - Arbuckle horizon standardization in 2-CHI SSA updated in SDJR'

# output directory
d <- '../2-CHI/FY2018/Arbuckle/'


# reports are stored in the same parent folder as this script
render(input = 'DMU-diff/report.Rmd',
       output_dir = d, 
       output_file = 'DMU-diff.html',
       params = list(projectname=p), 
       clean = TRUE
      )

render(input = 'QA-summary/report.Rmd',
       output_dir = d, 
       output_file = 'QA-summary.html',
       params = list(projectname=p), runtime = 'static', 
       clean = TRUE
)

