\name{prettySummary}
\alias{prettySummary}
\title{
Pretty Quantile Printing
}
\description{
This function generates a pretty quantile summary for printing.
}
\usage{
prettySummary(x, p = c(0, 0.25, 0.5, 0.75, 1), n = TRUE, signif = TRUE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{p}{a numeric vector of percentiles}
  \item{n}{a logical value indicating whether the vector of percentiles should be appended with the number of observations}
  \item{signif}{a logical value indicating whether the percentiles should be rounded to the precision of the data}
  }
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{a character value of quantiles and optionally the number of observations
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
Stephen Roecker
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
x <- 1.1:10.1
prettySummary(x)
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~manip }% use one of  RShowDoc("KEYWORDS")
