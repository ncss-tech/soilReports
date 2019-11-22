# MUPOLYGON Summary by Project

This report summarizes the zonal statistics for an MUPOLYGON layer within a file geodatabase. The spatial variables summarized include: elevation, slope, aspect, relief, preciptation, temperature, frost free period, and landcover. The report assumes the spatial data follows the proper folder hierachy and naming conventions (e.g. C:/geodata/project_data/11IND).

The spatial extent for the summary is derived from an MUPOLYGON layer contained in a file geodatabase. To select the desired map units for analysis specify the NASIS projectname. The projectname will be used to query NASIS via a web report and the nationalmusym linked to the proejct will be identified and used to subset the MUPOLYGON layer.


## Report Parameters

- NASIS Project Name (e.g. "EVAL - MLRA 111D - Fincastle silt loam, Southern Ohio Till Plain, 2 to 4 percent slopes")
- File Geodatabase Name (e.g. "RTSD_MLRA_11-IND_FY18.gdb")
- Geodata Project Data File Path (e.g. "M:/geodata/project_data/")
- MLRA Soil Survey Office Symbol (e.g. "11-IND")


## Variables

|Abbreviation |Measures                            |Unit                                 |Source                                                           |
|:------------|:-----------------------------------|:------------------------------------|:----------------------------------------------------------------|
|elev         |elevation                           |meters                               |30-meter USGS National Elevation Dataset (NED)                   |
|slope        |slope gradient                      |percent                              |10-meter NED                                                     |
|aspect       |slope aspect                        |degrees                              |10-meter NED                                                     |
|valley       |multiresolution valley bottom index |unitless                             |30-meter NED                                                     |
|wetness      |topographic Wetness index           |unitless                             |30-meter NED                                                     |
|relief       |height above channel                |meters                               |30-meter NED                                                     |
|ppt          |annual precipitation                |millimeters                          |800-meter 30-year normals (1981-2010) from PRISM Climate Dataset |
|temp         |annual air temperature              |degrees Celsius                      |800-meter 30-year normals (1981-2010) from PRISM Climate Dataset |
|ffp          |frost free period                   |days                                 |1000-meter 30-year normals (1961-1990) from USFS RMRS            |
|lulc         |land use and land cover             |landcover class (e.g. Wood Wetlands) |2011 National Land Cover Dataset (NLCD)                          |



## Example Output

[summary of mupolygon layer](http://ncss-tech.github.io/example-reports/mupolygon_report.html)


## Example

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
render(input = "C:/workspace2/mupolygon_summary/report.Rmd", 
       output_dir = "C:/workspace2", 
       output_file = "C:/workspace2/mupolygon_summary.html", 
       envir = new.env(), 
       params = list(
              projectname = "EVAL - MLRA 111D - Fincastle silt loam, Southern Ohio Till Plain, 2 to 4 percent slopes",
              geodatabase = "RTSD_MLRA_11-IND_FY18.gdb",
              project_data_file_path = "M:/geodata/project_data/",
              ssoffice = "11-IND"
              ))
```

