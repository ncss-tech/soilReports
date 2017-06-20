
# soilReports

Reports are a handy way to summarize large volumes of data, particularly with figures and tables. soilReports is an R package container and was developed to replicate NASIS's report repository. Currently soilReports contains a small collection of reports intended to assist with soil survey activities such as:

- populating soil components and developing official Series descriptions (OSD)
- performing quality control and assurance
- analyzing map unit polygons


**Requirements:**

- [The user is familiar with Rstudio](http://ncss-tech.github.io/stats_for_soil_survey/chapters/1_introduction/1_introduction.html)
- NASIS selected set is loaded with the necessary tables (e.g. "Project - legend/mapunit/dmu by sso, pname & uprojectid")
-	[ODBC connection to NASIS is setup](http://ncss-tech.github.io/AQP/soilDB/setup_local_nasis.html)
- [custom .Rprofile exists](https://github.com/ncss-tech/soilReports#pre-installation-nrcs-only-this-is-only-required-once)
- [necessary R packages are installed](http://ncss-tech.github.io/stats_for_soil_survey/chapters/0_pre-class-assignment/pre-class-assignment.html)


**Example output:**
  
  - [summary of select CA630 map units](http://ncss-tech.github.io/example-reports/mu-comparison/CA630-mu-comparison.html)
  - [summary of select MLRA polygons](http://ncss-tech.github.io/example-reports/mu-comparison/MLRA-comparison-report.html)
  - [summary of mupolygon layer](http://ncss-tech.github.io/example-reports/mupolygon_report.html)
  - [summary of soil components](http://ncss-tech.github.io/example-reports/component_report.html)
  - [summary of lab data](http://ncss-tech.github.io/example-reports/lab_report.html)
  - [summary of pedon data](http://ncss-tech.github.io/example-reports/pedon_report.html)
  
 **Additional Instructions:**
 
 - [Download the pdf files from the top section of this GitHub page](https://github.com/ncss-tech/soilReports/tree/master/docs), for background and instructions for the Map Unit Summary Report and instructions for the MLRA Comparison Report.
 
## Pre-Installation (NRCS only). This is only required once.

On many of our machines, the `$HOME` directory points to a network share. This can cause all kinds of problems when installing R packages, especially if you connect to the network by VPN. The following code is a one-time solution and will cause R packages to be installed on a local disk by adding an `.Rprofile` file to your `$HOME` directory. This file will instruct R to use `C:/Users/FirstName.LastName/Documents/R/` for installing R packages. Again, you only have to do this **once**.

```r
# run this in the R console
source('https://raw.githubusercontent.com/ncss-tech/soilReports/master/R/installRprofile.R')
installRprofile()
```

The following code can be used to "see" where the `$HOME` directory is. The result should look like "C:/Users/First.Last/Documents"

```r
# run this in the R console
path.expand('~')
```

## Installation of the soilReports package. Only required for first-time use of soilReports and when a new version of soilReports is released.

The current version of `soilReports` is installed with the following code:

```r
# need devtools to install packages from GitHub
install.packages('devtools', dep=TRUE)

# get the latest version of the 'soilReports' package
devtools::install_github("ncss-tech/soilReports", dependencies=FALSE, upgrade_dependencies=FALSE)
```

## Loading the soilReports library and downloading the required files. This is only required for first-time use.
The `soilReports` package contains reports and associated configuration files. The following steps perform all required setup for the **region2/mu-comparison** report, then copies the configuration (config.R) and report (report.Rmd) files to a folder that it creates named 'MU-comparison' in the working directory. Edit the `config.R` file (or replace it with an existing config.R in the working directory) so that it points to the correct raster layers and map unit polygons. "Knit" the report file by opening `report.Rmd` and clicking on the "Knit HTML" button. The package will put a 'report.html' file in the MU-comparison folder and will create a folder named 'output' for report-generated shapefiles.

```r
# load this library
library(soilReports)

# list reports in the package
listReports()

# install required packages for a named report
reportSetup(reportName='region2/mu-comparison')

# copy report file 'MU-comparison' to your current working directory
reportInit(reportName='region2/mu-comparison', outputDir='MU-comparison')
```

## Available Reports

### Map Unit Comparison/Summary Report.

This report was designed to assist with comparisons between map unit concepts via sampling of various raster data sources within map unit polygons. Configuration of data sources is done within `config.R`. Contact Dylan Beaudette (dylan.beaudette at ca.usda.gov) for questions or comments.

### MLRA Comparison/Summary Report.

This report was designed to assist with comparisons between MLRA concepts using a [pre-made raster sample database](https://github.com/ncss-tech/mlra-raster-db). You will need to put these database files into the same folder as `report.Rmd`. MLRA selection is done within `config.R`. Contact Dylan Beaudette (dylan.beaudette at ca.usda.gov) for questions or comments.

```r
# load this library
library(soilReports)

# install required packages for a named report
reportSetup(reportName='region2/mlra-comparison')

# copy default configuration file and report to 'MU-comparison' in current working directory
reportInit(reportName='region2/mlra-comparison', outputDir='MLRA-comparison')
```

Download the three raster sample databases into the directory created above.
```r
download.file('https://github.com/ncss-tech/mlra-raster-db/raw/master/rda-files/mlra-geomorphons-data.rda', 
destfile='MLRA-comparison/mlra-geomorphons-data.rda')

download.file('https://github.com/ncss-tech/mlra-raster-db/raw/master/rda-files/mlra-nlcd-data.rda', 
destfile='MLRA-comparison/mlra-nlcd-data.rda')

download.file('https://github.com/ncss-tech/mlra-raster-db/raw/master/rda-files/mlra-prism-data.rda', 
destfile='MLRA-comparison/mlra-prism-data.rda')

download.file('https://github.com/ncss-tech/mlra-raster-db/raw/master/rda-files/mlra-soil-data.rda', 
destfile='MLRA-comparison/mlra-soil-data.rda')
```

### Component Summary by Project

This report summarizes the components within an MLRA project. Several figures are generated to compare the component aomong several data mapunits.

Be sure to load your NASIS selected set using a query, such as "Project - legend/mapunit/dmu by sso, pname & uprojectid" from the Region 11 query folder.  

```r
# load the soilReports package
library(soilReports)
library(rmarkdown)

# run the report manually
## copy to your workspace2 folder

copyReport(reportName = "region11/component_summary_by_project", outputDir = "C:/workspace2/component_summary")

## open the "report.Rmd" file from "C:/workspace2/component_summary" in RStudio, and hit the "Knit HTML" button


## run the report via commandline
reports = listReports()
reports = subset(reports, name == "region11/component_summary_by_project")
render(input = reports$file.path, 
       output_dir = "C:/workspace2", 
       output_file = "C:/workspace2/comp_summary.html", 
       envir = new.env()
       )
```

### MUPOLYGON Summary by Project

This report summarizes the zonal statistics for the MUPOLYGON layer from a file geodatabase. The spatial variables summarized include: elevation, slope, aspect, relief, preciptation, temperature, frost free period, and landcover. The report assumes the spatial data follows the proper folder hierachy and naming conventions (e.g. C:/geodata/project_data/11IND).

Be sure to load your NASIS selected set using a query, such as "Project - legend/mapunit/dmu by sso, pname & uprojectid" from the Region 11 query folder. Check "Legend" and "Project" for National. Check "Project", "Mapunit", "DataMapunit", and "Legend Mapunit" for Local.

```r
# load the soilReports package
library(soilReports)
library(rmarkdown)

# run the report manually
## copy to your workspace2 folder

copyReport(reportName = "region11/mupolygon_summary_by_project", outputDir = "C:/workspace2/mupolygon_summary")

## Open the "report.Rmd" file from "C:/workspace2/mupolygon_summary" in RStudio, and hit the "Knit HTML" drop down arrow and select "Knit with Paramters..." menu item. Modify the parameters accordingly. 


## run the report via commandline
reports = listReports()
reports = subset(reports, name == "region11/mupolygon_summary_by_project")
render(input = reports$file.path, 
       output_dir = "C:/workspace2", 
       output_file = "C:/workspace2/mupolygon_summary.html", 
       envir = new.env(), 
       params = list(geodatabase = "RTSD_R11-IND_FY16.gdb",
                     project_data_file_path = "M:/geodata/project_data/",
                     ssoffice = "11IND"
                     ))
```


## Troubleshooting
 1. Make sure that all raster data sources are [GDAL-compatible formats](http://www.gdal.org/formats_list.html): GeoTiff, ERDAS IMG, ArcGRID, etc. (not ESRI FGDB)
 2. Make sure that the map unit polygon data source is an [OGR-compatible format](http://www.gdal.org/ogr_formats.html): ESRI SHP, ESRI FGDB, etc.
 3. Make sure that the extent of raster data includes the full extent of map unit polygon data.
 4. If there is a problem installing packages with `reportSetup()`, consider adding the `upgrade=TRUE` argument.
 5. If you are encountering errors with "Knit HTML" in RStudio, try: `update.packages(ask=FALSE, checkBuilt=TRUE)`.

## TODO
See [issue tracker](https://github.com/ncss-tech/soilReports/issues) for TODO items.

  

## Related Packages
 * [aqp](https://github.com/ncss-tech/aqp)
 * [soilDB](https://github.com/ncss-tech/soilDB)
 * [sharpshootR](https://github.com/ncss-tech/sharpshootR)
 
