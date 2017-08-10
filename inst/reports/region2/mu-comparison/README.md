# Map Unit Comparison/Summary Report

[Download the pdf files from the docs folder of this GitHub page](https://github.com/ncss-tech/soilReports/tree/master/docs), for background and instructions for the Map Unit Summary Report.

This report was designed to assist with comparisons between map unit concepts via sampling of various raster data sources within map unit polygons. Configuration of data sources is done within `config.R`. Contact Dylan Beaudette (dylan.beaudette at ca.usda.gov) for questions or comments.

## Typical Usage
The `soilReports` package contains reports and associated configuration files. The following steps perform all required setup for the **region2/mu-comparison** report, then copies the configuration (config.R) and report (report.Rmd) files to a folder that it creates named 'MU-comparison' in the working directory. Edit the `config.R` file (or replace it with an existing config.R in the working directory) so that it points to the correct raster layers and map unit polygons. "Knit" the report file by opening `report.Rmd` and clicking on the "Knit HTML" button. The package will put a 'report.html' file in the MU-comparison folder and will create a folder named 'output' for report-generated shapefiles.

```r
# load this library
library(soilReports)

# list reports in the package
listReports()

# install required packages for a named report
reportSetup(reportName='region2/mu-comparison')

# copy report file 'MU-comparison' to your current working directory
reportInit(reportName='region2/mu-comparison', outputDir='MU-comparison')
```

## Updating Existing Report
Updates to report templates, documentation, and custom functions are available *after installing the latest* `soilReports` package from GitHub. Use the following examples to update an existing copy of the "region2/mu-comparison" report. Note that your existing configuration files will not be modified.

```r
# get latest version of package + report templates
devtools::install_github("ncss-tech/soilReports", dependencies=FALSE, upgrade_dependencies=FALSE)

# load this library
library(soilReports)

# get any new packages that may be required by the latest version
reportSetup(reportName='region2/mu-comparison')

# overwrite report files in an existing report instance (does NOT overwrite config.R files)
reportUpdate(reportName='region2/mu-comparison', outputDir='MU-comparison')
```


## Troubleshooting
1. Make sure that all raster data sources are [GDAL-compatible formats](http://www.gdal.org/formats_list.html): GeoTiff, ERDAS IMG, ArcGRID, etc. (not ESRI FGDB)
2. Make sure that the map unit polygon data source is an [OGR-compatible format](http://www.gdal.org/ogr_formats.html): ESRI SHP, ESRI FGDB, etc.

