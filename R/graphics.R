##
##
##

# remove NA from $value
# compute density for $value, using 1.5x "default" bandwidth
# re-scale to {0,1}
# truncate to original range of $value
# return x,y values
#' Compute scaled density for a data.frame containing "value"
#' 
#' Gaussian probability densities are re-scaled to `[0,1]`
#'
#' @param d data.frame containing column "value"
#' @param constantScaling use `scales::rescale`? Default: `TRUE`
#'
#' @return A `data.frame` containing (scaled) `x` and `y`
#' @export
#'
scaled.density <- function(d, constantScaling=TRUE) {
  # basic density estimate
  v <- na.omit(d$value)
  
  if (length(v) == 1){
    res <- stats::density(v, kernel='gaussian', bw = 1)
  } else if (length(v) == 0) {
    res <- stats::density(c(0, 0), kernel="gaussian", bw = 1)
  } else {
    res <- stats::density(v, kernel='gaussian', adjust=1.5)
  }
  
  # optionally re-scale to {0,1}
  if(constantScaling) {
    if(!requireNamespace("scales"))
      stop('package `scales` is required', call. = FALSE)
    res$y <- scales::rescale(res$y)
  }
  
  # constrain to original range
  r <- range(v)
  idx.low <- which(res$x < r[1])
  idx.high <- which(res$x > r[2])
  
  # replace with NA
  res$x[c(idx.low, idx.high)] <- NA
  res$y[c(idx.low, idx.high)] <- NA
  
  return(data.frame(x=res$x, y=res$y))
}

# http://stackoverflow.com/questions/16225530/contours-of-percentiles-on-level-plot
#' Calculate kernel density contour lines at specified probability levels
#' Calculate kernel density contour lines at specified probability levels with `MASS:kde2d` and display with `graphics::contour`
#' @param i a data.frame containing unique ID, `x`, `y`
#' @param id a unique ID column name
#' @param prob a vector of probability levels
#' @param cols a vector of colors
#' @param m unique levels of the ID column (used to match colors)
#' @param ... additional arguments to `graphics::contour`
#'
#' @return estimated kernel density contours
#' @export
#'
kdeContours <- function(i, id, prob, cols, m, ...) {
  
  if (!requireNamespace("MASS"))
    stop('package `MASS` is required', call. = FALSE)
  
  if(nrow(i) < 2) {
    return(NULL)
  }
  
  this.id <- unique(i[[id]])
  this.col <- cols[match(this.id, m)]
  dens <- MASS::kde2d(i$x, i$y, n=200); ## estimate the z counts
  
  dx <- diff(dens$x[1:2])
  dy <- diff(dens$y[1:2])
  sz <- sort(dens$z)
  c1 <- cumsum(sz) * dx * dy
  levels <- sapply(prob, function(x) {
    approx(c1, sz, xout = 1 - x)$y
  })
  
  # add contours if possibly
  if(!is.na(levels))
    contour(dens, levels=levels, drawlabels=FALSE, add=TRUE, col=this.col, ...)
  
}


# custom stats for box-whisker plot: 5th-25th-50th-75th-95th percentiles
# NOTE: we are re-purposing the coef argument!
# x: vector of values to summarize
# coef: 
#' Title
#'
#' @param x  vector of values to summarize
#' @param coef Moran's I associated with the current raster
#' @param do.out not used
#'
#' @return a list containing elements: `stats`, `n`, `conf`, and `out`
#' @export
custom.bwplot <- function(x, coef=NA, do.out=FALSE) {
  # custom quantiles for bwplot
  stats <- quantile(x, p=c(0.05, 0.25, 0.5, 0.75, 0.95), na.rm = TRUE)
  # number of samples
  n <- length(na.omit(x))
  
  if(!is.na(coef)) {
    # compute effective sample size
    rho <- coef
    
    if(!requireNamespace("sharpshootR"))
      stop("package `sharpshootR is required", call. = FALSE)
    
    n_eff <- sharpshootR::ESS_by_Moran_I(n, rho)
    
    # confidence "notch" is based on ESS
    iqr <- stats[4] - stats[2]
    conf <- stats[3] + c(-1.58, 1.58) * iqr/sqrt(n_eff)
  } else {
    conf <- NA
  }
  
  out.low <- x[which(x < stats[1])]
  out.high <- x[which(x > stats[5])]
  
  return(list(stats=stats, n=n, conf=conf, out=c(out.low, out.high)))
}
