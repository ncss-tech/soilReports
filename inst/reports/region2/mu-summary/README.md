# Map Unit Summary Report--All Map Units

This report was designed to assist with comparisons between map unit concepts via sampling of various raster data sources within map unit polygons. Configuration of data sources is done within `config.R`. Example output [here](http://dylanbeaudette.github.io/static/GIS-summary-by-MU.html). Contact Dylan Beaudette (dylan.beaudette at ca.usda.gov) for questions or comments.


## Setup

## Troubleshooting
1. Make sure that all raster data sources are [GDAL-compatible formats](http://www.gdal.org/formats_list.html): GeoTiff, ERDAS IMG, ArcGRID, etc. (not ESRI FGDB)
2. Make sure that the map unit polygon data source is an [OGR-compatible format](http://www.gdal.org/ogr_formats.html): ESRI SHP, ESRI FGDB, etc.

