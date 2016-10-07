# soilReports
R package container and convenience functions for soil data summary, comparison, and evaluation reports used mainly by NRCS staff.


Install the development version from Github:

`devtools::install_github("ncss-tech/soilReports", dependencies=FALSE, upgrade_dependencies=FALSE)`

## Examples
```r
library(soilReports)

# list reports in the package
listReports()

# install a .Rprofile file, critical for NRCS users
installRprofile()

# install required packages for a named report
reportSetup('region2/mu-comparison')

# copy default configuration file to working directory
reportConfig('region2/mu-comparison')
```

## Related Packages
 * [aqp](https://github.com/ncss-tech/aqp)
 * [soilDB](https://github.com/ncss-tech/soilDB)
 * [sharpshootR](https://github.com/ncss-tech/sharpshootR)
 