# NASIS Pedon Spatial Overlay Report

Visualize NASIS pedons in interactive HTML report with overlays of SSURGO, STATSGO or custom polygons.

This report has {aqp}, {sf}, {mapview}, {knitr}, {soilDB} off CRAN and {NASIStools} off GitHub as dependencies.

To use the report:

1. Navigate to your desired parent working directory.

2. Run `soilReports::reportSetup("region2/spatial-pedons")` to install dependencies

3. Run `soilReports::reportInit("region2/spatial-pedons", outputDir = "spatial-pedons")` to install a report instance in `outputDir`. Specify `overwrite` argument as needed. Use `reportUpdate` if an existing older report instance is being updated and you want to preserve _config.R_ contents.

4. Navigate to `"spatial-pedons"` directory and inspect report contents. Open _report.Rmd_ in RStudio and click "Knit" button, or `render()` with {rmarkdown} manually.

## Core Report Components

 - _report.Rmd_ - main report document
 
 - _config.R_ - user-level configuration and options; should not be over-written by `reportUpdate`
 
 - _NEWS.md_ - Changelog (optional)
 
 
