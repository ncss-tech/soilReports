#' Indexing for Plotting and Printing
#'
#' This function creates an index to iterate over when plotting or printing large objects.
#' 
#' @param x a `data.frame`, `SoilProfileCollection` or `table`
#' @param interval a value specifying the interval length desired; Default: `4`
#'
#' @return a numeric vector
#' @export
#' @examples 
#' x <- as.data.frame(matrix(1:100, ncol = 10))
#' pIndex(x, interval = 3)
#' 
pIndex <- function(x, interval = 4){
  if (inherits(x, "data.frame")) { x1 <- ncol(x); x2 <- 1 }
  if (inherits(x, "SoilProfileCollection")) { x1 <- length(x); x2 <- 0 }
  if (inherits(x, "table")) { x1 <- ncol(x); x2 <- 0 }
  n <- x1 - x2
  times <- ceiling(n / interval)
  x <- rep(1:(times + x2), each = interval, length.out = n)
  return(x)
}


.precision <- function(x){
  if (!all(is.na(x))) {
    y = {format(x, scientific = FALSE, trim = TRUE) ->.;
      unlist(as.data.frame(strsplit(., "\\."))[2, ]) ->.;
      as.character(.) ->.;
      max(nchar(.))}
  } else y = 0
  if (is.na(y)) y = 0 else y = y
  return(y)
}


#' Pretty Quantile Printing
#' 
#' This function generates a pretty quantile summary for printing.
#' 
#' @param x a numeric vector
#' @param p a numeric vector of percentiles
#' @param n a logical value indicating whether the vector of percentiles should be appended with the number of observations
#' @param signif a logical value indicating whether the percentiles should be rounded to the precision of the data
#'
#' @return a character value of quantiles and optionally the number of observations
#' @author Stephen Roecker
#' @export
#' @examples 
#' x <- 1.1:10.1
#' prettySummary(x)
#'
prettySummary <- function(x, p = c(0, 0.25, 0.5, 0.75, 1), n = TRUE, signif = TRUE) {
  precision <- .precision(x)
  n_obs <- length(na.omit(x))
  ci <- quantile(x, na.rm = TRUE, probs = p)
  range <- paste0("(",
                  # precision
                  if (signif == TRUE) {
                    paste0(round(ci, precision), collapse = ", ")
                  } else
                    paste0(round(ci), collapse = ", ")
                  , ")" ,
                  # add (n_obs) column for pretty-printing
                  if (n == TRUE) {
                    paste0("(", n_obs, ")")
                  })
  return(range = range)
}


# tool to replace deprecated region names with new region names
.convert_region <- function(x) {
  if (grepl("^region[0-9]+.*$", x)) {
    lut <- c(region2 = "southwest",
             region11 = "northeast")
    old <- gsub("^(region[0-9])+.*$", "\\1", x)
    new <- gsub(paste0("^", old), lut[old], x)
    message("Replacing ", x, " with ", new)
    x <- new
  }
  if (!dir.exists(x)) {
    stop("Could not find report: ", x, call. = FALSE)
  }
  x
}