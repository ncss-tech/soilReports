pIndex <- function(x, interval = 4){
  if (class(x)[1] == "data.frame") {x1 <- ncol(x); x2 <- 1}
  if (class(x)[1] == "SoilProfileCollection") {x1 <- length(x); x2 <- 0}
  if (class(x)[1] == "table") {x1 <- ncol(x); x2 <- 0}
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


prettySummary <- function(x, p = c(0, 0.25, 0.5, 0.75, 1), n = TRUE, signif = TRUE) {
  precision <- .precision(x)
  n_obs <- length(na.omit(x))
  ci <- quantile(x, na.rm = TRUE, probs = p)
  range <- paste0("(",
                  # precision
                  if (signif == TRUE) {
                    paste0(round(ci, precision), collapse=", ") 
                  } else paste0(round(ci), collapse = ", ")
                  , ")" ,  
                  # add (n_obs) column for pretty-printing
                  if (n == TRUE) {paste0("(", n_obs, ")")}
                  )
  return(range = range)
  }
