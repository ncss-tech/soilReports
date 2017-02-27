\name{soilReports-package}
\alias{soilReports-package}
\alias{soilReports}
\alias{installRprofile}
\alias{listReports}
\alias{reportInit}
\alias{reportSetup}
\docType{package}
\title{Soil Reports: R-Markdown reports and convenience functions for soil survey.}
\description{R package container and convenience functions for soil data summary, comparison, and evaluation reports used mainly by USDA-NRCS staff.

\href{https://github.com/ncss-tech/soilReports}{Instructions and project homepage.}
}

\examples{
\dontrun{
# load this library
library(soilReports)

# list reports in the package
listReports()

# install required packages for a named report
reportSetup(reportName='region2/mu-comparison')

# copy default configuration file and report to 'MU-comparison' in current working directory
reportInit(reportName='region2/mu-comparison', outputDir='MU-comparison', overwrite=FALSE)
}
}

\author{Dylan E. Beaudette <dylan.beaudette@ca.usda.gov>}
\keyword{ package }


