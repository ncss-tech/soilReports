# QA Summary Report


## Typical Usage
Load the local NASIS database with two DMU that represent "pre" and "post" SDJR/update work. It is essential that the `mapunit`, `correlation`, and `DMU` objects are loaded in the selected set.

Local NASIS DB setup: 
   * load a single project by name
   * add data for new MLRA MU via project mapunit -> mapunit table
   * add data for new MLRA DMU via mapunit/correlation -> data mapunit table

Run the following commands to setup the report template.
```r
# load this library
library(soilReports)

# install required packages for this report
reportSetup(reportName='southwest/QA-summary')

# copy report folder 'QA-summary' to your current working directory
reportInit(reportName='southwest/QA-summary', outputDir='QA-summary')
```

Open `report.Rmd` and then click "knit". Configuration is based on the single project loaded into your selected set.

