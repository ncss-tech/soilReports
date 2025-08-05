# Zonal Statistics Report

This report calculates zonal statistics for specified polygons using raster data. The script leverages the `terra` and `exactextractr` packages to perform spatial operations and extract statistics.

## Prerequisites

Ensure you have the following R packages installed:

 - `terra`
 
 - `exactextractr`

You can install them using:
```r
reportSetup("national/zonal-statistics")
```

## Script Overview

### Configuration

- **mu.dsn**: Path to the parent folder of the shapefile (SHP), without a trailing forward slash.
- **mu.layer**: Name of the SHP file, without the file extension.
- **mu.col**: Column name in the SHP file to be used for grouping (e.g., 'MUKEY', 'MUSYM').
- **mu.set**: Vector of symbols of interest to subset the polygons.
- **raster.list**: Nested list of raster data categorized as continuous, categorical, or circular.
- **FUN**: Aggregation method to be used (e.g., "quantile").
- **ARGS**: Additional arguments for the aggregation function.
- **BY_POLYGON**: Boolean indicating whether to apply aggregation to each polygon (`TRUE`) or each group (`FALSE`).

### Script Steps

1. **Load and Subset Polygons**: 
   - Load the polygons from the specified vector data file (e.g. Shapefile)
   - Subset the polygons based on the symbols of interest

2. **Create SpatRasters**: 
   - Convert the raster file paths into `SpatRaster` objects

3. **Aggregate Polygons**: 
   - Aggregate the polygons if group statistics are required

4. **Prepare Spatial Object and Attributes**: 
   - Convert the polygons to an `sf` object
   - Calculate the area of each polygon in acres

5. **Extract and Apply Aggregation Function**: 
   - Extract statistics from the raster data using the specified aggregation function
   - Combine the results with the polygon attributes

### Output

The script outputs a data frame with the extracted statistics for each polygon or group, depending on the `BY_POLYGON` parameter.

## Usage

1. Run `soilReports::reportInit("national/zonal-statistics", outputDir = "zonal-test")` to install a report instance in `outputDir`. Specify `overwrite` argument as needed. Use `reportUpdate` if an existing older report instance is being updated and you want to preserve _config.R_ contents.

2. Navigate to your report instance in `outputDir` (e.g. `"zonal-test"` directory) and inspect folder contents.

3. Open _config.R_ and set the paths to data sources and other configuration

4. Open _report.Rmd_ in RStudio and click "Knit" button, or `render()` with {rmarkdown} manually.

5. View HTML report output, and tabular data files generated in `"output"` subfolder