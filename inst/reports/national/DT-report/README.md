# DT-report v 1.0 
- Create interactive data tables from CSV files

To use the report:

1. Navigate to your desired parent working directory.

2. Run `soilReports::reportSetup("national/DT-report")` to install dependencies

3. Run `soilReports::reportInit("national/DT-report", outputDir= "DT-report")` to install a report instance in `outputDir`. Specify `overwrite` argument as needed. Use `reportUpdate` if an existing older report instance is being updated and you want to preserve _config.R_ contents.

4. Navigate to `"DT-report"` directory and inspect report contents. Open _report.Rmd_ in RStudio and click "Knit" button, or `render()` with {rmarkdown} manually.

## Core Report Components

 - _report.Rmd_ - main report document
 
 - _config.R_ - user-level configuration and options for input file path; should not be over-written by `reportUpdate`
 
 - _NEWS.md_ - Changelog
 

 
