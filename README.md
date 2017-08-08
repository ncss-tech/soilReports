
# soilReports

Reports are a handy way to summarize large volumes of data, particularly with figures and tables. `soilReports` is an R package container and was developed to maintain, document, and distribute R-based reporting functionality.

## Requirements

 * [The user is familiar with Rstudio](http://ncss-tech.github.io/stats_for_soil_survey/chapters/1_introduction/1_introduction.html)
 * NASIS selected set is loaded with the necessary tables (e.g. "Project - legend/mapunit/dmu by sso, pname & uprojectid")
 * [ODBC connection to NASIS is setup](http://ncss-tech.github.io/AQP/soilDB/setup_local_nasis.html)
 * [custom .Rprofile exists](https://github.com/ncss-tech/soilReports#pre-installation-nrcs-only-this-is-only-required-once)
 * [necessary R packages are installed](http://ncss-tech.github.io/stats_for_soil_survey/chapters/0_pre-class-assignment/pre-class-assignment.html)


## Example Output
  
  - [summary of select CA630 map units](http://ncss-tech.github.io/example-reports/mu-comparison/CA630-mu-comparison.html)
  - [summary of select MLRA polygons](http://ncss-tech.github.io/example-reports/mu-comparison/MLRA-comparison-report.html)
  - [summary of mupolygon layer](http://ncss-tech.github.io/example-reports/mupolygon_report.html)
  - [summary of soil components](http://ncss-tech.github.io/example-reports/component_report.html)
  - [summary of lab data](http://ncss-tech.github.io/example-reports/lab_report.html)
  - [summary of pedon data](http://ncss-tech.github.io/example-reports/pedon_report.html)
  

## R Profile Setup

On many of our machines, the `$HOME` directory points to a network share. This can cause all kinds of problems when installing R packages, especially if you connect to the network by VPN. The following code is a one-time solution and will cause R packages to be installed on a local disk by adding an `.Rprofile` file to your `$HOME` directory. This file will instruct R to use `C:/Users/FirstName.LastName/Documents/R/` for installing R packages. Again, you only have to do this **once**.

```r
# determine your current $HOME directory
path.expand('~')

# install .Rprofile
source('https://raw.githubusercontent.com/ncss-tech/soilReports/master/R/installRprofile.R')
installRprofile()
```


## soilReports Installation
Run this code after a new version of R has been installed on your machine, or if you don't yet have the `soilReports` pacakge:
```r
# need devtools to install packages from GitHub
install.packages('devtools', dep=TRUE)

# get the latest version of the 'soilReports' package
devtools::install_github("ncss-tech/soilReports", dependencies=FALSE, upgrade_dependencies=FALSE)
```

## Loading the soilReports library and downloading the required files. This is only required for first-time use.
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

## Update an existing report (previously created with reportInit), while retaining configuration files:
```r
library(soilReports)

# get any new packages that may be required by the latest version
reportSetup(reportName='region2/mu-comparison')

# overwrite report files in an existing report instance (does NOT overwrite config)
reportUpdate(reportName='region2/mu-comparison', outputDir='MU-comparison')
```

## Available Reports

 * [Map Unit Comparison/Summary Report](https://github.com/ncss-tech/soilReports/tree/master/inst/reports/region2/mu-comparison)
 
 * [MLRA Comparison/Summary Report](https://github.com/ncss-tech/soilReports/tree/master/inst/reports/region2/mlra-comparison)

 * [Component Summary by Project](https://github.com/ncss-tech/soilReports/tree/master/inst/reports/region11/component_summary_by_project)
 
 * [MUPOLYGON Summary by Project](https://github.com/ncss-tech/soilReports/tree/master/inst/reports/region11/mupolygon_summary_by_project)




## R Upgrade Process
Periodically we receive an updated version of R via an automated software installation process; typically without warning. The new version of R does not have access to previously installed packages, resulting in report failing to run. In the future regional staff will provide as much notice as possible on the timing of these upgrades. The following code should be run after an R upgrade completes.

Copy the following lines of code into the R console and hit enter:
```r
# get devtools  
install.packages('devtools', dep=TRUE)
# get soilReports
devtools::install_github("ncss-tech/soilReports", dependencies=FALSE, upgrade_dependencies=FALSE)

# install packages required by reports
library(soilReports)
reportSetup(reportName='region2/mu-comparison')
reportSetup(reportName='region2/mlra-comparison')
```


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
 
