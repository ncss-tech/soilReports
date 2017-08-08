# MUPOLYGON Summary by Project

This report summarizes the zonal statistics for the MUPOLYGON layer from a file geodatabase. The spatial variables summarized include: elevation, slope, aspect, relief, preciptation, temperature, frost free period, and landcover. The report assumes the spatial data follows the proper folder hierachy and naming conventions (e.g. C:/geodata/project_data/11IND).

Be sure to load your NASIS selected set using a query, such as "Project - legend/mapunit/dmu by sso, pname & uprojectid" from the Region 11 query folder. Check "Legend" and "Project" for National. Check "Project", "Mapunit", "DataMapunit", and "Legend Mapunit" for Local.

```r
# load the soilReports package
library(soilReports)
library(rmarkdown)

# run the report manually
## copy to your workspace2 folder

copyReport(reportName = "region11/mupolygon_summary_by_project", outputDir = "C:/workspace2/mupolygon_summary")

## Open the "report.Rmd" file from "C:/workspace2/mupolygon_summary" in RStudio, and hit the "Knit HTML" drop down arrow and select "Knit with Paramters..." menu item. Modify the parameters accordingly. 


## run the report via commandline
reports = listReports()
reports = subset(reports, name == "region11/mupolygon_summary_by_project")
render(input = reports$file.path, 
       output_dir = "C:/workspace2", 
       output_file = "C:/workspace2/mupolygon_summary.html", 
       envir = new.env(), 
       params = list(geodatabase = "RTSD_R11-IND_FY16.gdb",
                     project_data_file_path = "M:/geodata/project_data/",
                     ssoffice = "11IND"
                     ))
```

