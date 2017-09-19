
# soilReports
Reports are a handy way to summarize large volumes of data, particularly with figures and tables. `soilReports` is an R package "container" designed to accommodate the maintenance, documentation, and distribution of [R-based reporting tools](http://rmarkdown.rstudio.com/). Inside the package are report templates, setup files, documentation, and example configuration files. 

The `soilReports` package provides a couple important helper functions that do most of the work:

 * `listReports()`: print a listing of the available reports, version numbers, and basic metadata
 * `reportSetup(...)`: download any R pacakges required by the named report, e.g. *"region2/mu-comparison"*
 * `reportInit(...)` | `reportCopy(...)`: copy a named report template into a specific directory
 * `reportUpdate(...)`: update a named report in a specific directory, replacing `report.Rmd` only

Each report contains several files:

 * `report.Rmd`: an [R Markdown file](http://rmarkdown.rstudio.com/) that is "knit" into a final HTML or DOC report
 * `README.md`: report-specific instructions
 * `custom.R`: report-specific functions
 * `categorical_definitions.R`: report-specific color mapping and metadata for categorical raster data (user-editable)
 * `config.R`: configuration file to set report parameters (user-editable)
 * `changes.txt`: notes on changes and associated version numbers


## R Profile Setup
On many of our machines, the `$HOME` directory points to a network share. This can cause all kinds of problems when installing R packages, especially if you connect to the network by VPN. The following code is a one-time solution and will cause R packages to be installed on a local disk by adding an `.Rprofile` file to your `$HOME` directory. This file will instruct R to use `C:/Users/FirstName.LastName/Documents/R/` for installing R packages. Again, you only have to do this **once**.

```r
# determine your current $HOME directory
path.expand('~')

# install .Rprofile
source('https://raw.githubusercontent.com/ncss-tech/soilReports/master/R/installRprofile.R')
installRprofile()
```


## soilReports Installation - First time or after R upgrade
Run this code if you don't yet have the `soilReports` package or after a new version of R has been installed on your machine.

```r
# need devtools to install packages from GitHub
install.packages('devtools', dep=TRUE)

# get the latest version of the 'soilReports' package
devtools::install_github("ncss-tech/soilReports", dependencies=FALSE, upgrade_dependencies=FALSE) 
```

## Choose an Available Report

  * Region 2
     + [Map Unit Comparison/Summary Report](https://github.com/ncss-tech/soilReports/tree/master/inst/reports/region2/mu-comparison)
     + [MLRA Comparison/Summary Report](https://github.com/ncss-tech/soilReports/tree/master/inst/reports/region2/mlra-comparison)
     + [DMU Difference Report](https://github.com/ncss-tech/soilReports/tree/master/inst/reports/region2/dmu-diff)

  * Region 11
     + [Component Summary by Project](https://github.com/ncss-tech/soilReports/tree/master/inst/reports/region11/component_summary_by_project)
     + [MUPOLYGON Summary by Project](https://github.com/ncss-tech/soilReports/tree/master/inst/reports/region11/mupolygon_summary_by_project)


## Example Output
  
  * [summary of select CA630 map units](http://ncss-tech.github.io/example-reports/mu-comparison/CA630-mu-comparison.html)
  * [summary of select MLRA polygons](http://ncss-tech.github.io/example-reports/mu-comparison/MLRA-comparison-report.html)
  * [summary of mupolygon layer](http://ncss-tech.github.io/example-reports/mupolygon_report.html)
  * [summary of soil components](http://ncss-tech.github.io/example-reports/component_report.html)
  * [summary of lab data](http://ncss-tech.github.io/example-reports/lab_report.html)
  * [summary of pedon data](http://ncss-tech.github.io/example-reports/pedon_report.html)
  * [DMU differences](http://ncss-tech.github.io/example-reports/dmu-diff-example.html)


## Run a Report - Example: Map Unit Comparison report

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

## Updating Existing Reports - Example: Map Unit Comparison report 
Updates to report templates, documentation, and custom functions are available *after installing the latest* `soilReports` package from GitHub. Use the following examples to update an existing copy of the "region2/mu-comparison" report. Note that your existing configuration files will not be modified.

```r
# get latest version of package + report templates
devtools::install_github("ncss-tech/soilReports", dependencies=FALSE, upgrade_dependencies=FALSE)

# load this library
library(soilReports)

# get any new packages that may be required by the latest version
reportSetup(reportName='region2/mu-comparison')

# overwrite report files in an existing report instance (does NOT overwrite config)
reportUpdate(reportName='region2/mu-comparison', outputDir='MU-comparison')
```

## Suggested Background Material

 * [The user is familiar with Rstudio](http://ncss-tech.github.io/stats_for_soil_survey/chapters/1_introduction/1_introduction.html) 
 * NASIS selected set is loaded with the necessary tables (e.g. "Project - legend/mapunit/dmu by sso, pname & uprojectid") 
 * [ODBC connection to NASIS is setup](http://ncss-tech.github.io/AQP/soilDB/setup_local_nasis.html) 
 * [custom .Rprofile exists](https://github.com/ncss-tech/soilReports#pre-installation-nrcs-only-this-is-only-required-once) 
 * [necessary R packages are installed](http://ncss-tech.github.io/stats_for_soil_survey/chapters/0_pre-class-assignment/pre-class-assignment.html)

## Troubleshooting
 * Make sure that all raster data sources are [GDAL-compatible formats](http://www.gdal.org/formats_list.html): GeoTiff, ERDAS IMG, ArcGRID, etc. (not ESRI FGDB)
 * Make sure that the map unit polygon data source is an [OGR-compatible format](http://www.gdal.org/ogr_formats.html): ESRI SHP, ESRI FGDB, etc.
 * Make sure that the extent of raster data includes the full extent of map unit polygon data.
 * If there is a problem installing packages with `reportSetup()`, consider adding the `upgrade=TRUE` argument.
 * If you are encountering errors with "Knit HTML" in RStudio, try: `update.packages(ask=FALSE, checkBuilt=TRUE)`.

## TODO
See [issue tracker](https://github.com/ncss-tech/soilReports/issues) for TODO items.


## Related Packages
 * [aqp](https://github.com/ncss-tech/aqp)
 * [soilDB](https://github.com/ncss-tech/soilDB)
 * [sharpshootR](https://github.com/ncss-tech/sharpshootR)
 
