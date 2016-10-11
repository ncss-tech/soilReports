# soilReports
R package container and convenience functions for soil data summary, comparison, and evaluation reports used mainly by NRCS staff.


Install the development version from Github:

```r
# need devtools to install packages from GitHub
install.packages('devtools', dep=TRUE)

# get the latest version of the `soilReports` package
devtools::install_github("ncss-tech/soilReports", dependencies=FALSE, upgrade_dependencies=FALSE)
```

## Examples
```r
library(soilReports)

# list reports in the package
listReports()

# install a .Rprofile file, critical for NRCS users
installRprofile()

# install required packages for a named report
reportSetup(reportName='region2/mu-comparison')

# copy default configuration file and report to named folder 
# in the current working directory
reportInit(reportName='region2/mu-comparison', outputDir='project-name-MU-comparison')

# edit config.R and run report in RStudio
```

## Related Packages
 * [aqp](https://github.com/ncss-tech/aqp)
 * [soilDB](https://github.com/ncss-tech/soilDB)
 * [sharpshootR](https://github.com/ncss-tech/sharpshootR)
 