# MLRA Comparison/Summary Report

Download the pdf files from the docs folder of [this GitHub page](https://github.com/ncss-tech/soilReports/tree/master/docs), for background and instructions for the MLRA Comparison Report.

This report was designed to assist with comparisons between MLRA concepts using a [pre-made raster sample database](https://github.com/ncss-tech/mlra-raster-db). You will need to put these database files into the same folder as `report.Rmd`. MLRA selection is done within `config.R`. Contact Dylan Beaudette (dylan.beaudette at ca.usda.gov) for questions or comments.

```r
# load this library
library(soilReports)

# install required packages for a named report
reportSetup(reportName='region2/mlra-comparison')

# copy default configuration file and report to 'MU-comparison' in current working directory
reportInit(reportName='region2/mlra-comparison', outputDir='MLRA-comparison')
```

Download the raster sample databases into the directory created above.
```r
download.file('https://github.com/ncss-tech/mlra-raster-db/raw/master/rda-files/mlra-geomorphons-data.rda', 
destfile='MLRA-comparison/mlra-geomorphons-data.rda')

download.file('https://github.com/ncss-tech/mlra-raster-db/raw/master/rda-files/mlra-nlcd-data.rda', 
destfile='MLRA-comparison/mlra-nlcd-data.rda')

download.file('https://github.com/ncss-tech/mlra-raster-db/raw/master/rda-files/mlra-prism-data.rda', 
destfile='MLRA-comparison/mlra-prism-data.rda')

download.file('https://github.com/ncss-tech/mlra-raster-db/raw/master/rda-files/mlra-soil-data.rda', 
destfile='MLRA-comparison/mlra-soil-data.rda')

download.file('https://github.com/ncss-tech/mlra-raster-db/raw/master/rda-files/mlra-namrad-data.rda', 
destfile='MLRA-comparison/mlra-namrad-data.rda')
```
## R Upgrade Process
Periodically we receive an updated version of R via an automated software installation process. The new version of R does not have access to previously installed packages, resulting in report failing to run. In the future regional staff will provide as much notice as possible on the timing of these upgrades. The following code should be run after an R upgrade completes.

Copy the following lines of code into the R console and hit enter:
```r

# get devtools  
install.packages('devtools', dep=TRUE)

# get soilReports
devtools::install_github("ncss-tech/soilReports", dependencies=FALSE, upgrade_dependencies=FALSE)

# install packages required by reports
library(soilReports)
reportSetup(reportName='region2/mlra-comparison')
```
