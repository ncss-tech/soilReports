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
