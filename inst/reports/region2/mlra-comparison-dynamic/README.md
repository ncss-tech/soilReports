# MLRA/LRU Comparison/Summary Report

This report was designed to assist with comparisons between MLRA/LRU concepts via sampling of various raster data sources within polygons. Configuration of data sources is done within `config.R`. Contact Dylan Beaudette (dylan.beaudette at ca.usda.gov) for questions or comments.

[Download the pdf files from the docs folder of this GitHub page](https://github.com/ncss-tech/soilReports/tree/master/docs), for background and instructions for the Map Unit Summary Report.

A brief description of the SSRO2-specifc raster data sources can be found [here](https://ncss-tech.github.io/soilReports/docs/region2_mu-comparison-data-sources.html).

## Typical Usage
The `soilReports` package contains reports and associated configuration files. The following steps perform all required setup for the **region2/mlra-comparison-dynamic** report, then copies the configuration (config.R) and report (report.Rmd) files to a folder that it creates named 'MU-comparison' in the working directory. Edit the `config.R` file (or replace it with an existing config.R in the working directory) so that it points to the correct raster layers and map unit polygons. "Knit" the report file by opening `report.Rmd` and clicking on the "Knit HTML" button. The package will put a 'report.html' file in the MU-comparison folder and will create a folder named 'output' for report-generated shapefiles.

```r
# load this library
library(soilReports)

# list reports in the package
listReports()

# install required packages for a named report
reportSetup(reportName='region2/mlra-comparison-dynamic')

# copy report file 'MU-comparison' to your current working directory
reportInit(reportName='region2/mlra-comparison-dynamic', outputDir='MLRA-dynamic')
```


## Troubleshooting
   1. Make sure that all raster data sources are [GDAL-compatible formats](http://www.gdal.org/formats_list.html): GeoTiff, ERDAS IMG, ArcGRID, etc. (not ESRI FGDB)
   
   2. Make sure that the polygon data source is an [OGR-compatible format](http://www.gdal.org/ogr_formats.html): ESRI SHP, ESRI FGDB, etc.
   
   3. Be sure to use a sampling density between 0.01 (LRU) and 0.001 (MLRA) points / ac.

