# Export Site Locations from NASIS

This is a report to create a spatial point layer for NASIS sites in your local database.

This report has {aqp} and {soilDB} off CRAN and GitHub as dependencies. Also, the {sf} package is used for writing spatial outputs.

To use the report:

1. Load desired sites into NASIS local database and selected set. Default behavior is to pull from selected set, you can also pull all sites in the local database by customizing report parameters.

2. Run `soilReports::reportSetup("national/NASIS-site-export")` to install dependencies

3. Run `soilReports::reportInit("national/NASIS-site-export", outputDir = "NASIS-site-export")` to install a report instance in `outputDir`. Specify `overwrite` argument as needed. Use `reportUpdate` if an existing older report instance is being updated and you want to preserve _config.R_ contents.

4. Navigate to `"NASIS-site-export"` directory. Open _report.Rmd_ in RStudio and click "Knit" drop-down menu, select "Knit with Parameters...". You can also `render()` with {rmarkdown} manually.

5. Specify Soil Survey Areas of interest (optional, comma-delimited), and toggle selected set or "null fragments are zero" behavior as needed. 

6. Specify output path, default will create a GeoPackage in the working directory called _NASIS-sites.gpkg_
