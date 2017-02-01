
## soilReports

R package conatiner and convenience funtions for soil data summary, comparison, and evaluation reports used mainly by NRCS staff.

## Pre-Installation (NRCS only)

On many of our machines, the `$HOME` directory points to a network share. This can cause all kinds of problems when installing R packages, especially if you connect to the network by VPN. The following code is a one-time solution and will cause R packages to be installed on a local disk by adding an `.Rprofile` file to your `$HOME` directory. This file will instruct R to use `C:/Users/First.Last/Documents/R/` for installing R packages. Again, you only have to do this **once**.

```r
# run this in the R console
source('https://raw.githubusercontent.com/ncss-tech/soilReports/master/R/installRprofile.R')
installRprofile()
```

The following code can be used to "see" where the `$HOME` directory is:
```r
# run this in the R console
path.expand('~')
```

## Installation

The current version of `soilReports` is available on GitHub, an can be installed with the following code:
```r
# need devtools to install packages from GitHub
install.packages('devtools', dep=TRUE)

# get the latest version of the 'soilReports' package
devtools::install_github("ncss-tech/soilReports", dependencies=FALSE, upgrade_dependencies=FALSE)
```

## Example Usage
The `soilReports` package contains reports and associated configuration files. The following steps illustrate an example session that performs all required setup for the **region2/mu-comparison** report, then copies the configuration and report files to a named folder in the working directory. Edit the `config.R` file (or copy an existing configuration file) so that it points to the correct raster layers and map unit polygons. "Knit" the report file by opening `report.Rmd` and clicking on the "Knit HTML" button.

```r
# load this library
library(soilReports)

# list reports in the package
listReports()

# install required packages for a named report
reportSetup(reportName='region2/mu-comparison')

# copy default configuration file and report to 'MU-comparison' in current working directory
reportInit(reportName='region2/mu-comparison', outputDir='MU-comparison')
```

## Available Reports

### Map Unit Comparison/Summary Report

This report was designed to assist with comparisons between map unit concepts via sampling of various raster data sources within map unit polygons. Configuration of data sources is done within `config.R`. Contact Dylan Beaudette (dylan.beaudette at ca.usda.gov) for questions or comments.


## Troubleshooting
 1. Make sure that all raster data sources are [GDAL-compatible formats](http://www.gdal.org/formats_list.html): GeoTiff, ERDAS IMG, ArcGRID, etc. (not ESRI FGDB)
 2. Make sure that the map unit polygon data source is an [OGR-compatible format](http://www.gdal.org/ogr_formats.html): ESRI SHP, ESRI FGDB, etc.
 3. Make sure that the extent of raster data includes the full extent of map unit polygon data.
 4. If there is a problem installing packages with `reportSetup()`, consider adding the `upgrade=TRUE` argument.
 5. If you are encountering errors with "Knit HTML" in RStudio, try: `update.packages(ask=FALSE, checkBuilt=TRUE)`.

## TODO
See [issue tracker](https://github.com/ncss-tech/soilReports/issues) for TODO items.

  

## Related Packages
 * [aqp](https://github.com/ncss-tech/aqp)
 * [soilDB](https://github.com/ncss-tech/soilDB)
 * [sharpshootR](https://github.com/ncss-tech/sharpshootR)
 
