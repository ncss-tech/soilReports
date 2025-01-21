# DMU Diff Report
This report provides [text differencing](https://en.wikipedia.org/wiki/Diff_utility) capabilities, applied to DMU/component records and component/horizon records queried from the selected set. Differences are higlighted in blue, deletions are in red, and additions are in green.

Local NASIS DB setup: 
   * load a single project by name
   * add data for new MLRA MU via project mapunit -> mapunit table
   * add data for related DMU via mapunit/correlation -> data mapunit table

## Typical Usage
Load the local NASIS database with two DMU that represent "pre" and "post" SDJR/update work. It is essential that the `mapunit`, `correlation`, and `DMU` objects are loaded in the selected set.

Run the following commands to setup a report template.
```r
# load this library
library(soilReports)

# install required packages for this report
reportSetup(reportName='southwest/dmu-diff')

# copy report file 'MU-comparison' to your current working directory
reportInit(reportName='southwest/dmu-diff', outputDir='DMU-diff')
```

Open `report.Rmd` and then click "knit". Configuration is based on the single project loaded into your selected set.
