# MLRA comparison utility functions

# remove NA from $value
# compute density for $value, using 1.5x "default" bandwidth
# re-scale to {0,1}
# truncate to original range of $value
# return x,y values
scaled.density <- function(d, constantScaling=TRUE) {
  # basic density estimate
  v <- na.omit(d$value)
  res <- stats::density(v, kernel='gaussian', adjust=1.5)
  
  # optionally re-scale to {0,1}
  if(constantScaling)
    res$y <- scales::rescale(res$y)
  
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
kdeContours <- function(i, prob, cols, m, ...) {
  
  if(nrow(i) < 2) {
    return(NULL)
  }
  
  this.id <- unique(i$mlra)
  this.col <- cols[match(this.id, m)]
  dens <- kde2d(i$x, i$y, n=200); ## estimate the z counts
  
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


# cut down to reasonable size: using cLHS
f.subset <- function(i, n, non.id.vars) {
  # if there are more than n records, then sub-sample
  if(nrow(i) > n) {
    # columns with IDs have been pre-filtered
    idx <- clhs(i[, non.id.vars], size=n, progress=FALSE, simple=TRUE, iter=1000)
    i.sub <- i[idx, ]
  }
  #	otherwise use what we have
  else
    i.sub <- i
  
  return(i.sub)
}



# stat summary function
f.summary <- function(i, p) {
  
  # remove NA
  v <- na.omit(i$value)
  
  # compute quantiles
  q <- quantile(v, probs=p)
  res <- data.frame(t(q))
  
  ## TODO: implement better MADM processing and explanation  
  if(nrow(res) > 0) {
    #     # MADM: MAD / median
    #     # take the natural log of absolute values of MADM
    #     res$log_abs_madm <- log(abs(mad(v) / median(v)))
    #     # 0's become -Inf: convert to 0
    #     res$log_abs_madm[which(is.infinite(res$log_abs_madm))] <- 0
    
    # assign reasonable names (quantiles)
    names(res) <- c(paste0('Q', p * 100))
    
    return(res)
  }
  else
    return(NULL)
}

# custom stats for box-whisker plot: 5th-25th-50th-75th-95th percentiles
# x: vector of values to summarize
custom.bwplot <- function(x, coef=1.5, do.out=FALSE) {
  # custom quantiles for bwplot
  stats <- quantile(x, p=c(0.05, 0.25, 0.5, 0.75, 0.95), na.rm = TRUE)
  # number of samples
  n <- length(na.omit(x))
  
  out.low <- x[which(x < stats[1])]
  out.high <- x[which(x > stats[5])]
  
  return(list(stats=stats, out=c(out.low, out.high)))
}

