# Map Unit Comparison/Summary Report

This report was designed to assist with comparisons between map unit concepts via sampling of various raster data sources within map unit polygons. Configuration of data sources is done within `config.R`. Contact Dylan Beaudette (dylan.beaudette at ca.usda.gov) for questions or comments.

[Download the pdf files from the docs folder of this GitHub page](https://github.com/ncss-tech/soilReports/tree/master/docs), for background and instructions for the Map Unit Summary Report.

A brief description of the SSRO2-specifc raster data sources can be found [here](https://ncss-tech.github.io/soilReports/docs/region2_mu-comparison-data-sources.html).

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
remotes::install_github("ncss-tech/soilReports", dependencies=FALSE, upgrade=FALSE, build=FALSE)

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

You may have to manually install the `latticeExtra` and `caTools` packages.
```r
# install previous version of latticeExtra until we are at R >= 3.6.0
install.packages('https://cran.r-project.org/src/contrib/Archive/latticeExtra/latticeExtra_0.6-28.tar.gz', repos = NULL)

# temporary CRAN fix - get previous version of caTools
install.packages('https://cran.microsoft.com/snapshot/2019-04-15/bin/windows/contrib/3.6/caTools_1.17.1.2.zip', repos = NULL)
```

