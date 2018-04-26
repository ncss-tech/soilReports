# DMU Diff Report
This report provides [text differencing](https://en.wikipedia.org/wiki/Diff_utility) capabilities, applied to DMU/component records and component/horizon records queried from the selected set. Differences are higlighted in blue, deletions are in red, and additions are in green.

## Typical Usage
Load the local NASIS database with two DMU that represent "pre" and "post" SDJR/update work. It is essential that the `mapunit`, `correlation`, and `DMU` objects are loaded in the selected set.

Run the following commands to setup a report template.
```r
# load this library
library(soilReports)

# install required packages for this report
reportSetup(reportName='region2/dmu-diff')

# copy report file 'MU-comparison' to your current working directory
reportInit(reportName='region2/dmu-diff', outputDir='DMU-diff')
```

Edit the associated `config.R` document with the DMU descriptions that represent the *old* and *new* records. Open `report.Rmd` and click on the "Knit" button.
