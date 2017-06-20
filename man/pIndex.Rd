\name{pIndex}
\alias{pIndex}
\title{
Indexing for Plotting and Printing
}
\description{
This function creates an index to iterate over when plotting or printing large objects.
}
\usage{
pIndex(x, interval = 4)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{x}{a data frame, soilProfileCollection or table}
  \item{interval}{a value specifying the interval length desired}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{A vector of numeric values.
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
%%  ~~who you are~~
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
x <- as.data.frame(matrix(1:100, ncol = 10))
pIndex(x, interval = 3)
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~manip }% use one of  RShowDoc("KEYWORDS")
