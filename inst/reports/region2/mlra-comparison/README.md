# MLRA Comparison/Summary Report

Download the pdf files from the docs folder of [this GitHub page](https://github.com/ncss-tech/soilReports/tree/master/docs), for background and instructions for the MLRA Comparison Report.

This report was designed to assist with comparisons between MLRA concepts using a [pre-made raster sample database](https://github.com/ncss-tech/mlra-raster-db). You will need to put these database files into the same folder as `report.Rmd`. MLRA selection is done within `config.R`. Contact Dylan Beaudette (dylan.beaudette at ca.usda.gov) for questions or comments.

```r
# load this library
library(soilReports)

# install required packages for a named report
reportSetup(reportName='region2/mlra-comparison')

# copy default configuration file and report to 'MLRA-comparison' in current working directory
reportInit(reportName='region2/mlra-comparison', outputDir='MLRA-comparison')
```

Download the raster sample databases into the directory created above.
```r
# landform elements via geomorphons algorithm
download.file('https://github.com/ncss-tech/mlra-raster-db/raw/master/rda-files/mlra-geomorphons-data.rda', 
destfile='MLRA-comparison/mlra-geomorphons-data.rda')

# NLCD
download.file('https://github.com/ncss-tech/mlra-raster-db/raw/master/rda-files/mlra-nlcd-data.rda', 
destfile='MLRA-comparison/mlra-nlcd-data.rda')

# 800m PRISM stack
download.file('https://github.com/ncss-tech/mlra-raster-db/raw/master/rda-files/mlra-prism-data.rda', 
destfile='MLRA-comparison/mlra-prism-data.rda')

# monthly PPT 800m PRISM stack
download.file('https://github.com/ncss-tech/mlra-raster-db/raw/master/rda-files/mlra-monthly-ppt-data.rda', 
destfile='MLRA-comparison/mlra-monthly-ppt-data.rda')

# monthly PET 800m PRISM stack
download.file('https://github.com/ncss-tech/mlra-raster-db/raw/master/rda-files/mlra-monthly-pet-data.rda', 
destfile='MLRA-comparison/mlra-monthly-pet-data.rda')

# ISSR-800 soil properties
download.file('https://github.com/ncss-tech/mlra-raster-db/raw/master/rda-files/mlra-soil-data.rda', 
destfile='MLRA-comparison/mlra-soil-data.rda')

# gamma radiometrics
download.file('https://github.com/ncss-tech/mlra-raster-db/raw/master/rda-files/mlra-namrad-data.rda', 
destfile='MLRA-comparison/mlra-namrad-data.rda')

# 2015 population density
download.file('https://github.com/ncss-tech/mlra-raster-db/raw/master/rda-files/mlra-pop2015-data.rda', 
destfile='MLRA-comparison/mlra-pop2015-data.rda')
```

## Example for Updating Existing Report
Updates to report templates, documentation, and custom functions are available *after installing the latest* `soilReports` package from GitHub. Use the following examples to update an existing copy of the "region2/mlra-comparison" report. Note that your existing configuration files will not be modified.


```r
# get latest version of package + report templates
devtools::install_github("ncss-tech/soilReports", dependencies=FALSE, upgrade_dependencies=FALSE)

# load this library
library(soilReports)

# get any new packages that may be required by the latest version
reportSetup(reportName='region2/mlra-comparison')

# overwrite report files in an existing report instance (does NOT overwrite config.R files)
reportUpdate(reportName='region2/mlra-comparison', outputDir='MLRA-comparison')
```
