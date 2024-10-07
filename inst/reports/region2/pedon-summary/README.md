To install and run this report, run the following commands:

1. Install latest version of soilReports from GitHub: 

```r
remotes::install_github("ncss-tech/soilReports")
```

2. Install required packages for `"pedon-summary"` report:

```r
soilReports::reportSetup('region2/pedon-summary')
```

3. Create a fresh instance of `"pedon-summary"` in path `"C:/workspace2/pedon-summary"`: 

```r
soilReports::reportInit('region2/pedon-summary', "C:/workspace2/pedon-summary")
```

4. Navigate to `"C:/workspace2/pedon-summary"` (or selected output folder from #3) and open _config.R_

5. In _config.R_ update subset rules, regular expression patterns, generalized horizon label rules, and spatial data sources.

6. Open _report.Rmd_ and click "Knit" button in RStudio