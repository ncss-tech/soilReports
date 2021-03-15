# minimal `soilReports` template

This report has {aqp}, {soilDB} and {sharpshootR} off CRAN and GitHub as dependencies. It makes a couple simple graphics from the [{soilDB} documentation](https://ncss-tech.github.io/soilDB/docs/).

The input vectors of soil names for fetching OSDs etc. are customizable in _config.R_. 

To use the report:

1. Navigate to your desired parent working directory.

2. Run `soilReports::reportSetup("templates/minimal")` to install dependencies

3. Run `soilReports::reportInit("templates/minimal", outputDir = "minimal-test")` to install a report instance in `outputDir`. Specify `overwrite` argument as needed. Use `reportUpdate` if an existing older report instance is being updated and you want to preserve _config.R_ contents.

4. Navigate to `"minimal-test"` directory and inspect report contents. Open _report.Rmd_ in RStudio and click "Knit" button, or `render()` with {Rmarkdown} manually.

## Core Report Components

 - _setup.R_ - used internally by {soilReports}, must be defined in `inst/reports/` folder for each report. Defines dependencies and manifest of files that are copied to user file system.
 
 - _report.Rmd_ - main report document
 
 - _config.R_ - user-level configuration and options; should not be over-written by `reportUpdate`
 
 - _NEWS.md_ - Changelog (optional)
 
 - _README.md_ - Narrative and free-form description of report (rendered by GitHub as "index" for each folder; optional)
 
 
