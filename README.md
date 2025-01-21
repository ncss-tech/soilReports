<!-- badges: start -->
[![R-CMD-check](https://github.com/ncss-tech/soilReports/actions/workflows/R-CMD-check.yml/badge.svg)](https://github.com/ncss-tech/soilReports/actions/workflows/R-CMD-check.yml)
<!-- badges: end -->

# soilReports
Reports are a handy way to summarize large volumes of data, particularly with figures and tables. `soilReports` is an R package "container" designed to accommodate the maintenance, documentation, and distribution of [R-based reporting tools](http://rmarkdown.rstudio.com/). Inside the package are report templates, setup files, documentation, and example configuration files. 

The `soilReports` package provides a couple important helper functions that do most of the work:

 * `listReports()`: print a listing of the available reports, version numbers, and basic metadata
 * `reportSetup(...)`: download any R packages required by the named report, e.g. *"southwest/mu-comparison"*
 * `reportInit(...)` | `reportCopy(...)`: copy a named report template into a specific directory
 * `reportUpdate(...)`: update a named report in a specific directory, replacing `report.Rmd` only

Each report contains several files:

 * `report.Rmd`: an [R Markdown file](http://rmarkdown.rstudio.com/) that is "knit" into a final HTML or DOC report
 * `README.md`: report-specific instructions
 * `custom.R`: report-specific functions
 * `categorical_definitions.R`: report-specific color mapping and metadata for categorical raster data (user-editable)
 * `config.R`: configuration file to set report parameters (user-editable)
 * `changes.txt`: notes on changes and associated version numbers



<!-- mark for deletion -->
## R Profile Setup

**NOTE: The following instructions are rarely, if ever, needed with R 4.2+**

On many of our machines, the `$HOME` directory points to a network share. This can cause all kinds of problems when installing R packages, especially if you connect to the network by VPN. The following code is a one-time solution and will cause R packages to be installed on a local disk by adding an `.Rprofile` file to your `$HOME` directory. This file will instruct R to use `C:/Users/FirstName.LastName/Documents/R/` for installing R packages. Again, you only have to do this **once**.

```r
# determine your current $HOME directory
path.expand('~')

# install .Rprofile
source('https://raw.githubusercontent.com/ncss-tech/soilReports/master/R/installRprofile.R')
installRprofile(overwrite=TRUE)
```


## soilReports Installation - First time or after R upgrade
Run this code if you don't yet have the `soilReports` package or after a new version of R has been installed on your machine.

```r
# need devtools to install packages from GitHub
install.packages('remotes', dep = TRUE)

# get the latest version of the 'soilReports' package
remotes::install_github("ncss-tech/soilReports", dependencies = FALSE, upgrade_dependencies = FALSE) 
```

## Choose an Available Report

  * Region 2
     + [Map Unit Comparison/Summary Report](https://github.com/ncss-tech/soilReports/tree/master/inst/reports/southwest/mu-comparison)
     + [MLRA Comparison/Summary Report](https://github.com/ncss-tech/soilReports/tree/master/inst/reports/southwest/mlra-comparison)
     + [DMU Difference Report](https://github.com/ncss-tech/soilReports/tree/master/inst/reports/southwest/dmu-diff)
     + [QA Summary Report](https://github.com/ncss-tech/soilReports/tree/master/inst/reports/southwest/QA-summary)
     + [Shiny Pedon Summary](https://github.com/ncss-tech/soilReports/tree/master/inst/reports/southwest/shiny-pedon-summary)
     
  * Region 11
     + [Component Summary by Project](https://github.com/ncss-tech/soilReports/tree/master/inst/reports/northeast/component_summary_by_project)
     + [MUPOLYGON Summary by Project](https://github.com/ncss-tech/soilReports/tree/master/inst/reports/northeast/mupolygon_summary_by_project)


## Example Output

### Reports for Raster Summary by MU or MLRA
  
  * [summary of select CA630 map units](http://ncss-tech.github.io/example-reports/mu-comparison/CA630-mu-comparison.html)
  * [summary of select MLRA](http://ncss-tech.github.io/example-reports/MLRA-comparison.html)
  * [summary of mupolygon layer](http://ncss-tech.github.io/example-reports/mupolygon_report.html)

### Reports for DMU QC/QA

  * [DMU differences](http://ncss-tech.github.io/example-reports/dmu-diff-example.html)
  * [QA Summary](http://ncss-tech.github.io/example-reports/QA-summary-example.html)
  * [DMU Summary](http://ncss-tech.github.io/example-reports/DMU-summary-example.html)
  * [summary of soil components](http://ncss-tech.github.io/example-reports/component_report.html)
  

### Reports for Pedon Data

  * [CA792: mendel](http://ncss-tech.github.io/example-reports/CA792-pedon/mendel.html)
  * [CA792: canisrocks](http://ncss-tech.github.io/example-reports/CA792-pedon/canisrocks.html)
  * [CA792: siberian](http://ncss-tech.github.io/example-reports/CA792-pedon/siberian.html)
  * [CA792: isosceles](http://ncss-tech.github.io/example-reports/CA792-pedon/isosceles.html)
  * [summary of pedon data](http://ncss-tech.github.io/example-reports/pedon_report.html)
  * [summary of lab data](http://ncss-tech.github.io/example-reports/lab_report.html)
  * [NEW: Shiny Pedon Summary - interactive plots and tables for pedon data](https://ncss-tech.github.io/soilReports/docs/shiny-pedon-summary/shiny-pedon_loafercreek-taxadjuncts.PNG)


## Run a Report - Example: Map Unit Comparison report

```r
# load this library
library(soilReports)

# list reports in the package
listReports()

# install required packages for a named report
reportSetup(reportName='southwest/mu-comparison')

# copy report file 'MU-comparison' to your current working directory
reportInit(reportName='southwest/mu-comparison', outputDir='MU-comparison')
```

## Updating Existing Reports - Example: Map Unit Comparison report 
Updates to report templates, documentation, and custom functions are available *after installing the latest* `soilReports` package from GitHub. Use the following examples to update an existing copy of the "southwest/mu-comparison" report. Note that your existing configuration files will not be modified.

```r
# get latest version of package + report templates
remotes::install_github("ncss-tech/soilReports", dependencies=FALSE, upgrade_dependencies=FALSE)

# load this library
library(soilReports)

# get any new packages that may be required by the latest version
reportSetup(reportName='southwest/mu-comparison')

# overwrite report files in an existing report instance (does NOT overwrite config)
reportUpdate(reportName='southwest/mu-comparison', outputDir='MU-comparison')
```

## Suggested Background Material

 * [The user is familiar with Rstudio](http://ncss-tech.github.io/stats_for_soil_survey/chapters/1_introduction/1_introduction.html)
 * NASIS selected set is loaded with the necessary tables (e.g. "Project - legend/mapunit/dmu by sso, pname & uprojectid")
 * [ODBC connection to NASIS is setup](http://ncss-tech.github.io/AQP/soilDB/setup_local_nasis.html)
 * [custom .Rprofile exists](https://github.com/ncss-tech/soilReports#pre-installation-nrcs-only-this-is-only-required-once)
 * [necessary R packages are installed](http://ncss-tech.github.io/stats_for_soil_survey/chapters/0_pre-class-assignment/pre-class-assignment.html)

## Troubleshooting
 * If you haven't run R in a while, consider updating all packages with: `update.packages(ask=FALSE, checkBuilt=TRUE)`.
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
 
