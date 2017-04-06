pindex <- function(x, interval){
  if (class(x)[1] == "data.frame") {x1 <- ncol(x); x2 <- 1}
  if (class(x)[1] == "SoilProfileCollection") {x1 <- length(x); x2 <-0}
  if (class(x)[1] == "table") {x1 <- ncol(x); x2 <- 0}
  n <- x1 - x2
  times <- ceiling(n / interval)
  x <- rep(1:(times + x2), each = interval, length.out = n)
  }

na_replace <- function(x){
  if(class(x)[1] == "character" | class(x)[1] == "logical") 
    {x <- replace(x, is.na(x) | x == "NA", "missing")} 
  else (x <-  x)
  }

na_remove <- function(df, by = 2){
  df[, which(apply(df, by, function(x) !all(is.na(x))))]
  }

precision.f <- function(x){
  if (!all(is.na(x))) {
    y = {format(x, scientific = FALSE, trim = TRUE) ->.;
      unlist(as.data.frame(strsplit(., "\\."))[2, ]) ->.;
      as.character(.) ->.;
      max(nchar(.))}
    } else y = 0
  if (is.na(y)) y = 0 else y = y
  return(y)
  }


sum5n <- function(x, n = NULL) {
  variable <- unique(x$variable)
  precision <- precision.f(x$value)
  n <- length(na.omit(x$value))
  ci <- data.frame(rbind(quantile(x$value, na.rm = TRUE, probs = p)))
  ci$range <- paste0("(", paste0(round(ci, precision), collapse=", "), ")", "(", n, ")") # add 'range' column for pretty-printing
  return(ci["range"])
}

sum5n2 <- function(x) {
  variable <- unique(x$variable)
  v <- na.omit(x$value) # extract column, from long-formatted input data
  precision <- if(variable == 'Circularity') 1 else 0
  ci <- data.frame(rbind(quantile(x$value, na.rm = TRUE, probs = p)))
  ci$range <- with(ci, paste0("(", paste0(round(ci, precision), collapse=", "), ")")) # add 'range' column for pretty-printing
  return(ci["range"])
}
