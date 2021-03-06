% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/graphics.R
\name{scaled.density}
\alias{scaled.density}
\title{Compute scaled density for a data.frame containing "value"}
\usage{
scaled.density(d, constantScaling = TRUE)
}
\arguments{
\item{d}{data.frame containing column "value"}

\item{constantScaling}{use \code{scales::rescale}? Default: \code{TRUE}}
}
\value{
A \code{data.frame} containing (scaled) \code{x} and \code{y}
}
\description{
Gaussian probability densities are re-scaled to \verb{[0,1]}
}
