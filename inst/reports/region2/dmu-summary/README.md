# DMU Summary Report

## Usage

Run the following commands to setup the report template.

```r
# load this library
library(soilReports)

# install required packages for this report
reportSetup(reportName='region2/dmu-summary')

# copy report folder 'dmu-summary' to your current working directory
reportInit(reportName='region2/dmu-summary', outputDir='dmu-summary')
```

This report requires loading several related objects into your NASIS Selected Set, including Area, Legend Mapunit, Correlation, Component Pedon, Pedon and Site Observation. 

A useful NASIS query that gets all of the necessary objects is **_NSSC Pangaea_: _Area/Legend/Mapunit/DMU/Pedon/Site by areasymbol_**.

 - This query has detailed instructions for loading necessary data, and includes only representative data map units. Several other variants of this same query can be used to obtain data based on component or pedon information rather than area symbol.

Open `report.Rmd`, review the "params" section of the YAML header to select target mapunit and cache file name, then click "knit". You can cache the data for many map units (e.g. a whole soil survey area) once, then re-run the report several times with different `musym` values. To force new data to be loaded from the database, delete the .rda file specified in `cache_file` in the document directory.
