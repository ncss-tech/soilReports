# soilReports
R package container and convenience functions for soil data summary, comparison, and evaluation reports used mainly by NRCS staff.


## Installation

### Personal R package library work-around (probably NRCS-specific)
Check to see if your `$HOME` directory points to a network share:
```r
path.expand('~')
```

If the results look something like `H:/Documents`, then you will need to redirect package installation to a local disk. This is accomplished by installing a `.Rprofile` file in your `$HOME` directory. If you have previously created a `.Rprofile` then skip the following step. Otherwise, run:

```r
source('https://raw.githubusercontent.com/ncss-tech/soilReports/master/R/installRprofile.R')
installRprofile()
```

The current version of `soilReports` is available on GitHub:
```r
# need devtools to install packages from GitHub
install.packages('devtools', dep=TRUE)

# get the latest version of the `soilReports` package
devtools::install_github("ncss-tech/soilReports", dependencies=FALSE, upgrade_dependencies=FALSE)
```

## Example Usage
The `soilReports` package contains reports and associated configuration files. The following steps illustrate an example session that performs all required setup for the **region2/mu-comparison** report, then copies the configuration and report files to a named folder in the working directory.

```r
# load this library
library(soilReports)

# list reports in the package
listReports()

# install required packages for a named report
reportSetup(reportName='region2/mu-comparison')

# copy default configuration file and report to 'MU-comparison' in current working directory
reportInit(reportName='region2/mu-comparison', outputDir='MU-comparison')

# edit config.R and 'knit' report.Rmd via RStudio
```

## Available Reports

### Map Unit Comparison/Summary Report

This report was designed to assist with comparisons between map unit concepts via sampling of various raster data sources within map unit polygons. Configuration of data sources is done within `config.R`. Contact Dylan Beaudette (dylan.beaudette at ca.usda.gov) for questions or comments.


## Troubleshooting
1. Make sure that all raster data sources are [GDAL-compatible formats](http://www.gdal.org/formats_list.html): GeoTiff, ERDAS IMG, ArcGRID, etc. (not ESRI FGDB)
2. Make sure that the map unit polygon data source is an [OGR-compatible format](http://www.gdal.org/ogr_formats.html): ESRI SHP, ESRI FGDB, etc.
3. Make sure that the extent of raster data includes the full extent of map unit polygon data.
4. If there is a problem installing packages with `reportSetup()`, consider running `update.packages(ask=FALSE, checkBuilt = TRUE)`.

## TODO: 
  1. estimate effective DF from spatial data: 
    1. http://www.inside-r.org/packages/cran/SpatialPack/docs/modified.ttest
  2. test for "separation" between map units based on supervised classification results
  3. better tests for bugs related to small sample sizes and low variability, currently using SD < 1e-5 as threshold
    + clhs() breaks when sd == 0
    + masking 5-95 pctile interval results in not enough data for MDS
    + figure out reasonable heuristic (multi-variate CV?)
  4. drop some quantiles from tab. summaries and add mean, SD, CV
  5. test for raster extents smaller than MU extent
  6. extentPlot() <- graphical display of extents
  
## Report Distribtuion and Maintenance (ASAP)
See ticket #173.



## Related Packages
 * [aqp](https://github.com/ncss-tech/aqp)
 * [soilDB](https://github.com/ncss-tech/soilDB)
 * [sharpshootR](https://github.com/ncss-tech/sharpshootR)
 