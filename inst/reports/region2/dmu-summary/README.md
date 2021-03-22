# DMU Summary Report
PENDING

## Typical Usage
This report requires setting up a selected set in your local NASIS database:

   * load legend by area symbol
   * load related MU (approved / provisional only)
   * load related DMU (rep DMU only)
   * load related component pedons
   * load related site observation

Run the following commands to setup the report template.
```r
# load this library
library(soilReports)

# install required packages for this report
reportSetup(reportName='region2/dmu-summary')

# copy report folder 'dmu-summary' to your current working directory
reportInit(reportName='region2/dmu-summary', outputDir='dmu-summary')
```

TODO: Setup `cached.rds`.

TODO: specification of map unit symbol via `params`

Open `report.Rmd` and then click "knit".

