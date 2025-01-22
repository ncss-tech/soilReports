# Component Summary by Project

This report summarizes the components within an MLRA project. Several figures are generated to compare the component aomong several data mapunits.

Be sure to load your NASIS selected set using a query, such as "Project - legend/mapunit/dmu by sso, pname & uprojectid" from the Region 11 query folder.  

```r
# load the soilReports package
library(soilReports)
library(rmarkdown)

# run the report manually
## copy to your workspace2 folder

copyReport(reportName = "northcentral/component_summary_by_project", outputDir = "C:/workspace2/component_summary")

## open the "report.Rmd" file from "C:/workspace2/component_summary" in RStudio, and hit the "Knit HTML" button


## run the report via commandline
reports = listReports()
reports = subset(reports, name == "northcentral/component_summary_by_project")
render(input = reports$file.path, 
       output_dir = "C:/workspace2", 
       output_file = "C:/workspace2/comp_summary.html", 
       envir = new.env()
       )
```
