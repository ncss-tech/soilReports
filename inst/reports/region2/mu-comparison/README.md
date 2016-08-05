# Map Unit Comparison/Summary Report

This report was designed to assist with comparisons between map unit concepts via sampling of various raster data sources within map unit polygons. Configuration of data sources is done within `config.R`. Example output [here](http://dylanbeaudette.github.io/static/GIS-summary-by-MU.html). Contact Dylan Beaudette (dylan.beaudette at ca.usda.gov) for questions or comments.


## Setup
1. Put the files `GIS-summary-by-MU.Rmd`, `config.R`, and `load-packages.R` into a new folder. Run the contents of `load-packages.R` to install any missing packages. Report output will be saved in this folder.

2. Edit the `config.R` file to point to map unit polygons and raster data sources to be summarized.

3. Adjust sampling density and map unit label columns as needed in `config.R`.

4. Open the file `GIS-summary-by-MU.Rmd` and click on the "Knit HTML" button in RStudio.

## Troubleshooting
1. Make sure that all raster data sources are [GDAL-compatible formats](http://www.gdal.org/formats_list.html): GeoTiff, ERDAS IMG, ArcGRID, etc. (not ESRI FGDB)
2. Make sure that the map unit polygon data source is an [OGR-compatible format](http://www.gdal.org/ogr_formats.html): ESRI SHP, ESRI FGDB, etc.

## TODO: 
  1. estimate effective DF from spatial data: 
    1. http://www.inside-r.org/packages/cran/SpatialPack/docs/modified.ttest
  2. test for "separation" between map units based on supervised classification results
  3. better tests for bugs related to small sample sizes and low variability, currently using SD < 1e-5 as threshold
    + clhs() breaks when sd == 0
    + masking 5-95 pctile interval results in not enough data for MDS
    + figure out reasonable heuristic (multi-variate CV?)
  4. drop some quantiles from tab. summaries and add mean, SD, CV
  5. check: installation of old knitr before installation of other packages correct?
  
## Report Distribtuion and Maintenance (ASAP)
See ticket #173.

  
