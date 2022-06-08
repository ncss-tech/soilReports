# EDIT Soil Features Report

This report consists of _two_ Rmarkdown files. _report.Rmd_ is the main workhorse. It can be run for individual ecological sites by updating the default values in the YAML header `params` section. _batch.Rmd_ is used to run multiple instances of _report.Rmd_ on sets of ecological sites that have data in your local NASIS database; it programattically updates the Rmarkdown parameters for each run, and stores some of the data from your local database in memory between runs to save time.

1. Navigate to your desired parent working directory in R. 

2. Run `soilReports::reportSetup("region2/edit-soil-features")` to install dependencies

3. Run `soilReports::reportInit("region2/edit-soil-features", outputDir = "EDITSoilFeatures")` to install a report instance in `outputDir`. Specify `overwrite` argument as needed. 

4. Navigate to `"EDITSoilFeatures"` directory and inspect report contents. Open _report.Rmd_ in RStudio and click "Knit" button, or `render()` with {rmarkdown} manually.

## Core Report Components

 - _report.Rmd_ - main report document, can be run for individual sites by updating YAML header at top of file
 
 - _batch.Rmd_ - handles configuration and rendering of multiple reports
 
